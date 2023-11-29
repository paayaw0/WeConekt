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

ActiveRecord::Schema[7.0].define(version: 2023_11_29_015533) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "room_id"
    t.boolean "current", default: false
    t.datetime "last_connected_at"
    t.index ["room_id"], name: "index_connections_on_room_id"
    t.index ["user_id"], name: "index_connections_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "room_id"
    t.datetime "seen_at"
    t.boolean "copy", default: false
    t.integer "copied_to"
    t.integer "copied_from"
    t.integer "delete_for_current_user_id"
    t.boolean "delete_for_everyone", default: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "room_configurations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.interval "disappearing_messages"
    t.boolean "chat_lock_enabled"
    t.string "chat_lock_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_room_configurations_on_room_id"
    t.index ["user_id"], name: "index_room_configurations_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_type", default: 0
  end

  create_table "rooms_shared_messages", id: false, force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "shared_message_id", null: false
    t.index ["room_id", "shared_message_id"], name: "index_rooms_shared_messages_on_room_id_and_shared_message_id"
    t.index ["shared_message_id", "room_id"], name: "index_rooms_shared_messages_on_shared_message_id_and_room_id"
  end

  create_table "shared_messages", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "room_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_shared_messages_on_message_id"
    t.index ["room_id"], name: "index_shared_messages_on_room_id"
    t.index ["user_id"], name: "index_shared_messages_on_user_id"
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
    t.boolean "online", default: false
    t.datetime "last_seen_at"
  end

  add_foreign_key "connections", "rooms"
  add_foreign_key "connections", "users"
  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users"
  add_foreign_key "room_configurations", "rooms"
  add_foreign_key "room_configurations", "users"
  add_foreign_key "shared_messages", "messages"
  add_foreign_key "shared_messages", "rooms"
  add_foreign_key "shared_messages", "users"
end
