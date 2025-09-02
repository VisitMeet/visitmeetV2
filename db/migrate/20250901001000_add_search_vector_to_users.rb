class AddSearchVectorToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :search_vector, :tsvector
    add_index :users, :search_vector, using: :gin

    execute <<-SQL
      CREATE OR REPLACE FUNCTION users_search_vector_trigger() RETURNS trigger AS $$
      BEGIN
        NEW.search_vector :=
          setweight(to_tsvector('english', coalesce(NEW.country, '')), 'A') ||
          setweight(to_tsvector('english', coalesce((
            SELECT string_agg(location_tags.location, ' ')
            FROM location_tags
            JOIN user_location_tags ON user_location_tags.location_tag_id = location_tags.id
            WHERE user_location_tags.user_id = NEW.id
          ), '')), 'B') ||
          setweight(to_tsvector('english', coalesce((
            SELECT string_agg(profession_tags.profession, ' ')
            FROM profession_tags
            JOIN user_profession_tags ON user_profession_tags.profession_tag_id = profession_tags.id
            WHERE user_profession_tags.user_id = NEW.id
          ), '')), 'B') ||
          setweight(to_tsvector('english', coalesce(NEW.bio, '')), 'C');
        RETURN NEW;
      END
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER users_search_vector_update
      BEFORE INSERT OR UPDATE ON users
      FOR EACH ROW EXECUTE FUNCTION users_search_vector_trigger();

      CREATE OR REPLACE FUNCTION refresh_users_search_vector() RETURNS trigger AS $$
      BEGIN
        UPDATE users SET search_vector =
          setweight(to_tsvector('english', coalesce(country, '')), 'A') ||
          setweight(to_tsvector('english', coalesce((
            SELECT string_agg(location_tags.location, ' ')
            FROM location_tags
            JOIN user_location_tags ON user_location_tags.location_tag_id = location_tags.id
            WHERE user_location_tags.user_id = users.id
          ), '')), 'B') ||
          setweight(to_tsvector('english', coalesce((
            SELECT string_agg(profession_tags.profession, ' ')
            FROM profession_tags
            JOIN user_profession_tags ON user_profession_tags.profession_tag_id = profession_tags.id
            WHERE user_profession_tags.user_id = users.id
          ), '')), 'B') ||
          setweight(to_tsvector('english', coalesce(bio, '')), 'C')
        WHERE id = COALESCE(NEW.user_id, OLD.user_id);
        RETURN NULL;
      END
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER user_location_tags_search_vector_refresh
      AFTER INSERT OR DELETE OR UPDATE ON user_location_tags
      FOR EACH ROW EXECUTE FUNCTION refresh_users_search_vector();

      CREATE TRIGGER user_profession_tags_search_vector_refresh
      AFTER INSERT OR DELETE OR UPDATE ON user_profession_tags
      FOR EACH ROW EXECUTE FUNCTION refresh_users_search_vector();

      UPDATE users SET search_vector =
        setweight(to_tsvector('english', coalesce(country, '')), 'A') ||
        setweight(to_tsvector('english', coalesce((
          SELECT string_agg(location_tags.location, ' ')
          FROM location_tags
          JOIN user_location_tags ON user_location_tags.location_tag_id = location_tags.id
          WHERE user_location_tags.user_id = users.id
        ), '')), 'B') ||
        setweight(to_tsvector('english', coalesce((
          SELECT string_agg(profession_tags.profession, ' ')
          FROM profession_tags
          JOIN user_profession_tags ON user_profession_tags.profession_tag_id = profession_tags.id
          WHERE user_profession_tags.user_id = users.id
        ), '')), 'B') ||
        setweight(to_tsvector('english', coalesce(bio, '')), 'C');
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS user_location_tags_search_vector_refresh ON user_location_tags;
      DROP TRIGGER IF EXISTS user_profession_tags_search_vector_refresh ON user_profession_tags;
      DROP FUNCTION IF EXISTS refresh_users_search_vector();
      DROP TRIGGER IF EXISTS users_search_vector_update ON users;
      DROP FUNCTION IF EXISTS users_search_vector_trigger();
    SQL
    remove_index :users, :search_vector
    remove_column :users, :search_vector
  end
end
