class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.text :description
      t.date :event_date
      t.decimal :budget, precision: 10, scale: 2
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.boolean :assignments_generated, default: false

      t.timestamps
    end
  end
end
