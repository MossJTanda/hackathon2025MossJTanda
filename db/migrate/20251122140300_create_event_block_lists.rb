class CreateEventBlockLists < ActiveRecord::Migration[8.1]
  def change
    create_table :event_block_lists do |t|
      t.references :event, null: false, foreign_key: true
      t.references :blocker, null: false, foreign_key: { to_table: :users }
      t.references :blocked, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :event_block_lists, [:event_id, :blocker_id, :blocked_id], unique: true, name: 'index_event_blocks_on_event_blocker_blocked'
  end
end
