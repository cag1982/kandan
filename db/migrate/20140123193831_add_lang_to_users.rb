class AddLangToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lang, :string, limit: 2
    add_index :users, :lang
  end
end
