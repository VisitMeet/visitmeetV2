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
            SELECT string_agg(tags.name, ' ')
            FROM tags
            JOIN user_tags ON user_tags.tag_id = tags.id
            WHERE user_tags.user_id = NEW.id
          ), '')), 'B');
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
            SELECT string_agg(tags.name, ' ')
            FROM tags
            JOIN user_tags ON user_tags.tag_id = tags.id
            WHERE user_tags.user_id = users.id
          ), '')), 'B')
        WHERE id = NEW.user_id;
        RETURN NULL;
      END
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER user_tags_search_vector_refresh
      AFTER INSERT OR DELETE OR UPDATE ON user_tags
      FOR EACH ROW EXECUTE FUNCTION refresh_users_search_vector();
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS user_tags_search_vector_refresh ON user_tags;
      DROP FUNCTION IF EXISTS refresh_users_search_vector();
      DROP TRIGGER IF EXISTS users_search_vector_update ON users;
      DROP FUNCTION IF EXISTS users_search_vector_trigger();
    SQL
    remove_index :users, :search_vector
    remove_column :users, :search_vector
  end
end
