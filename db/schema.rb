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

ActiveRecord::Schema[7.1].define(version: 2025_07_20_090100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "location"
    t.decimal "price"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "offering_id", null: false
    t.date "requested_date", null: false
    t.integer "guests", default: 1, null: false
    t.text "message"
    t.integer "status", default: 0, null: false
    t.decimal "total_amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offering_id"], name: "index_bookings_on_offering_id"
    t.index ["requested_date"], name: "index_bookings_on_requested_date"
    t.index ["status"], name: "index_bookings_on_status"
    t.index ["user_id", "offering_id"], name: "index_bookings_on_user_id_and_offering_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "recipient_id", null: false
    t.bigint "typing_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
    t.index ["sender_id", "recipient_id"], name: "index_conversations_on_sender_id_and_recipient_id", unique: true
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
    t.index ["typing_user_id"], name: "index_conversations_on_typing_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
  end

  create_table "location_tags", force: :cascade do |t|
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "user_id", null: false
    t.text "body", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["conversation_id", "created_at"], name: "index_messages_on_conversation_id_and_created_at"
    t.index ["read_at"], name: "index_messages_on_read_at"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.string "message"
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "offerings", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "price"
    t.string "location"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "rates"
    t.string "contact_info"
    t.string "vehicle_type"
    t.boolean "availability"
    t.integer "number_of_beds"
    t.text "amenities"
    t.string "address"
    t.datetime "check_in_time"
    t.datetime "check_out_time"
    t.string "duration"
    t.text "itinerary"
    t.integer "group_size"
    t.float "latitude"
    t.float "longitude"
    t.index ["user_id"], name: "index_offerings_on_user_id"
  end

  create_table "profession_tags", force: :cascade do |t|
    t.string "profession"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "offering_id", null: false
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offering_id"], name: "index_reviews_on_offering_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "tag_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_identities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_user_identities_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_user_identities_on_user_id"
  end

  create_table "user_location_tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "location_tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_tag_id"], name: "index_user_location_tags_on_location_tag_id"
    t.index ["user_id"], name: "index_user_location_tags_on_user_id"
  end

  create_table "user_profession_tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "profession_tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profession_tag_id"], name: "index_user_profession_tags_on_profession_tag_id"
    t.index ["user_id"], name: "index_user_profession_tags_on_user_id"
  end

  create_table "user_tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_user_tags_on_tag_id"
    t.index ["user_id"], name: "index_user_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "full_name"
    t.string "provider"
    t.string "uid"
    t.string "country"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "users"
  add_foreign_key "bookings", "offerings"
  add_foreign_key "bookings", "users"
  add_foreign_key "conversations", "users", column: "recipient_id"
  add_foreign_key "conversations", "users", column: "sender_id"
  add_foreign_key "conversations", "users", column: "typing_user_id"
  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "offerings", "users"
  add_foreign_key "reviews", "offerings"
  add_foreign_key "reviews", "users"
  add_foreign_key "user_identities", "users"
  add_foreign_key "user_location_tags", "location_tags"
  add_foreign_key "user_location_tags", "users"
  add_foreign_key "user_profession_tags", "profession_tags"
  add_foreign_key "user_profession_tags", "users"
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users"
end
