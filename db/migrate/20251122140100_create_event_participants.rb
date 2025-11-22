class CreateEventParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :event_participants do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :preferences
      t.text :exclusions

      t.timestamps
    end

    add_index :event_participants, [:event_id, :user_id], unique: true
  end
end
