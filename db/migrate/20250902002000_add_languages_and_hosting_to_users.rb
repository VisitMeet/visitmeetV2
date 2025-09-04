class AddLanguagesAndHostingToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :languages, :string
    add_column :users, :hosting_available, :boolean, default: false
  end
end
