class AddSearchVectorToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :search_vector, :tsvector
    add_index :users, :search_vector, using: :gin

    execute <<~SQL
      CREATE OR REPLACE FUNCTION update_users_search_vector(user_row users) RETURNS tsvector AS $$
        SELECT 
          setweight(to_tsvector('simple', coalesce(user_row.country, '')), 'A') ||
          setweight(to_tsvector('simple', coalesce((SELECT string_agg(lt.location, ' ') FROM location_tags lt JOIN user_location_tags ult ON lt.id = ult.location_tag_id WHERE ult.user_id = user_row.id), '')), 'B') ||
          setweight(to_tsvector('simple', coalesce((SELECT string_agg(pt.profession, ' ') FROM profession_tags pt JOIN user_profession_tags upt ON pt.id = upt.profession_tag_id WHERE upt.user_id = user_row.id), '')), 'B');
      $$ LANGUAGE sql IMMUTABLE;

      CREATE OR REPLACE FUNCTION users_search_vector_trigger() RETURNS trigger AS $$
      BEGIN
        NEW.search_vector := update_users_search_vector(NEW);
        RETURN NEW;
      END
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER users_search_vector_update BEFORE INSERT OR UPDATE ON users
      FOR EACH ROW EXECUTE FUNCTION users_search_vector_trigger();

      CREATE OR REPLACE FUNCTION refresh_users_search_vector() RETURNS trigger AS $$
      DECLARE
        uid integer;
      BEGIN
        uid := CASE WHEN TG_OP = 'DELETE' THEN OLD.user_id ELSE NEW.user_id END;
        UPDATE users SET search_vector = update_users_search_vector(users.*) WHERE users.id = uid;
        RETURN NULL;
      END
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER user_location_tags_search_vector_trigger
      AFTER INSERT OR UPDATE OR DELETE ON user_location_tags
      FOR EACH ROW EXECUTE FUNCTION refresh_users_search_vector();

      CREATE TRIGGER user_profession_tags_search_vector_trigger
      AFTER INSERT OR UPDATE OR DELETE ON user_profession_tags
      FOR EACH ROW EXECUTE FUNCTION refresh_users_search_vector();

      UPDATE users SET search_vector = update_users_search_vector(users.*);
    SQL
  end

  def down
    execute <<~SQL
      DROP TRIGGER IF EXISTS user_profession_tags_search_vector_trigger ON user_profession_tags;
      DROP TRIGGER IF EXISTS user_location_tags_search_vector_trigger ON user_location_tags;
      DROP FUNCTION IF EXISTS refresh_users_search_vector();
      DROP TRIGGER IF EXISTS users_search_vector_update ON users;
      DROP FUNCTION IF EXISTS users_search_vector_trigger();
      DROP FUNCTION IF EXISTS update_users_search_vector(users);
    SQL
    remove_index :users, :search_vector
    remove_column :users, :search_vector
  end
end
