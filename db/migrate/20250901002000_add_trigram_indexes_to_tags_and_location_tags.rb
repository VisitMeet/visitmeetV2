class AddTrigramIndexesToTagsAndLocationTags < ActiveRecord::Migration[7.1]
  def up
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')
    add_index :tags, :name, using: :gin, opclass: :gin_trgm_ops
    add_index :location_tags, :location, using: :gin, opclass: :gin_trgm_ops
  end

  def down
    remove_index :tags, :name if index_exists?(:tags, :name)
    remove_index :location_tags, :location if index_exists?(:location_tags, :location)
  end
end
