class CreateFriendRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :friend_requests do |t|
      t.references :requester, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.string :status, default: 'pending', null: false

      t.timestamps
    end

    add_index :friend_requests, [:requester_id, :recipient_id], unique: true
  end
end
