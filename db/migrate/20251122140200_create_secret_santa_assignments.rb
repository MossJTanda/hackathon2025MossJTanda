class CreateSecretSantaAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :secret_santa_assignments do |t|
      t.references :event, null: false, foreign_key: true
      t.references :giver, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :secret_santa_assignments, [:event_id, :giver_id], unique: true
    add_index :secret_santa_assignments, [:event_id, :receiver_id], unique: true
  end
end
