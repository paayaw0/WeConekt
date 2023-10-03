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

ActiveRecord::Schema[7.0].define(version: 2023_10_03_143542) do
  create_table "connections", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_id"
    t.integer "message_id"
    t.index ["message_id"], name: "index_connections_on_message_id"
    t.index ["room_id"], name: "index_connections_on_room_id"
    t.index ["user_id"], name: "index_connections_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "text"
    t.integer "connection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "room_id"
    t.index ["connection_id"], name: "index_messages_on_connection_id"
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_type", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_logged_in_at"
    t.datetime "last_logged_out_at"
  end

  add_foreign_key "connections", "messages"
  add_foreign_key "connections", "rooms"
  add_foreign_key "connections", "users"
  add_foreign_key "messages", "connections"
  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users"
end
