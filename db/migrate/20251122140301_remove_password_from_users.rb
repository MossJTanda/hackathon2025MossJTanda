class RemovePasswordFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :password_digest, :string
    add_column :users, :username, :string
    add_index :users, :username, unique: true
  end
end
