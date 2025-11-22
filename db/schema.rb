# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_22_140301) do
  create_table "books", force: :cascade do |t|
    t.string "author"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "event_block_lists", force: :cascade do |t|
    t.integer "blocked_id", null: false
    t.integer "blocker_id", null: false
    t.datetime "created_at", null: false
    t.integer "event_id", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked_id"], name: "index_event_block_lists_on_blocked_id"
    t.index ["blocker_id"], name: "index_event_block_lists_on_blocker_id"
    t.index ["event_id", "blocker_id", "blocked_id"], name: "index_event_blocks_on_event_blocker_blocked", unique: true
    t.index ["event_id"], name: "index_event_block_lists_on_event_id"
  end

  create_table "event_participants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "event_id", null: false
    t.text "exclusions"
    t.string "preferences"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["event_id", "user_id"], name: "index_event_participants_on_event_id_and_user_id", unique: true
    t.index ["event_id"], name: "index_event_participants_on_event_id"
    t.index ["user_id"], name: "index_event_participants_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.boolean "assignments_generated", default: false
    t.decimal "budget", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.integer "created_by_id", null: false
    t.text "description"
    t.date "event_date"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_events_on_created_by_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "book_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.integer "rating"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["book_id"], name: "index_reviews_on_book_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "secret_santa_assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "event_id", null: false
    t.integer "giver_id", null: false
    t.integer "receiver_id", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "giver_id"], name: "index_secret_santa_assignments_on_event_id_and_giver_id", unique: true
    t.index ["event_id", "receiver_id"], name: "index_secret_santa_assignments_on_event_id_and_receiver_id", unique: true
    t.index ["event_id"], name: "index_secret_santa_assignments_on_event_id"
    t.index ["giver_id"], name: "index_secret_santa_assignments_on_giver_id"
    t.index ["receiver_id"], name: "index_secret_santa_assignments_on_receiver_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "event_block_lists", "events"
  add_foreign_key "event_block_lists", "users", column: "blocked_id"
  add_foreign_key "event_block_lists", "users", column: "blocker_id"
  add_foreign_key "event_participants", "events"
  add_foreign_key "event_participants", "users"
  add_foreign_key "events", "users", column: "created_by_id"
  add_foreign_key "reviews", "books"
  add_foreign_key "reviews", "users"
  add_foreign_key "secret_santa_assignments", "events"
  add_foreign_key "secret_santa_assignments", "users", column: "giver_id"
  add_foreign_key "secret_santa_assignments", "users", column: "receiver_id"
end
