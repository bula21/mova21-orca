# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_24_181501) do

  # These are extensions that must be enabled in order to support this database
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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.jsonb "label", default: {}
    t.jsonb "description", default: {}
    t.string "block_type"
    t.integer "participants_count_activity"
    t.integer "participants_count_transport"
    t.string "duration_activity"
    t.string "duration_journey"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "simo"
    t.integer "min_participants"
    t.string "activity_type"
    t.bigint "transport_location_id"
    t.integer "language_flags"
    t.bigint "activity_category_id"
    t.index ["activity_category_id"], name: "index_activities_on_activity_category_id"
    t.index ["transport_location_id"], name: "index_activities_on_transport_location_id"
  end

  create_table "activities_goals", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "goal_id", null: false
    t.index ["activity_id", "goal_id"], name: "index_activities_goals_on_activity_id_and_goal_id"
    t.index ["goal_id", "activity_id"], name: "index_activities_goals_on_goal_id_and_activity_id"
  end

  create_table "activities_stufen", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "stufe_id", null: false
    t.index ["activity_id", "stufe_id"], name: "index_activities_stufen_on_activity_id_and_stufe_id"
    t.index ["stufe_id", "activity_id"], name: "index_activities_stufen_on_stufe_id_and_activity_id"
  end

  create_table "activities_stufen_recommended", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "stufe_id", null: false
  end

  create_table "activities_tags", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "tag_id", null: false
    t.index ["activity_id", "tag_id"], name: "index_activities_tags_on_activity_id_and_tag_id"
    t.index ["tag_id", "activity_id"], name: "index_activities_tags_on_tag_id_and_activity_id"
  end

  create_table "activity_categories", force: :cascade do |t|
    t.jsonb "label", default: {}
    t.string "ancestry"
    t.string "code"
    t.index ["ancestry"], name: "index_activity_categories_on_ancestry"
  end

  create_table "goals", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invoice_parts", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.string "type"
    t.decimal "amount"
    t.string "label"
    t.string "breakdown"
    t.integer "ordinal"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["invoice_id"], name: "index_invoice_parts_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "unit_id", null: false
    t.string "type"
    t.date "issued_at", default: -> { "CURRENT_TIMESTAMP" }
    t.date "payable_until"
    t.datetime "sent_at"
    t.text "text"
    t.text "invoice_address"
    t.string "ref"
    t.decimal "amount", default: "0.0"
    t.boolean "paid", default: false
    t.string "payment_info_type"
    t.integer "category", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["unit_id"], name: "index_invoices_on_unit_id"
  end

  create_table "kvs", force: :cascade do |t|
    t.string "name", null: false
    t.integer "pbs_id", null: false
    t.string "locale", null: false
    t.index ["pbs_id"], name: "index_kvs_on_pbs_id", unique: true
  end

  create_table "leaders", force: :cascade do |t|
    t.integer "pbs_id"
    t.string "last_name"
    t.string "first_name"
    t.string "scout_name"
    t.date "birthdate"
    t.string "gender"
    t.string "email"
    t.string "phone_number"
    t.string "language"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
    t.string "zip_code"
    t.string "town"
    t.string "country"
  end

  create_table "mobility_string_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.string "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_string_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_string_translations_on_keys", unique: true
    t.index ["translatable_type", "key", "value", "locale"], name: "index_mobility_string_translations_on_query_keys"
  end

  create_table "mobility_text_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.text "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_text_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_text_translations_on_keys", unique: true
  end

  create_table "participant_units", force: :cascade do |t|
    t.bigint "unit_id", null: false
    t.bigint "participant_id", null: false
    t.index ["participant_id"], name: "index_participant_units_on_participant_id"
    t.index ["unit_id"], name: "index_participant_units_on_unit_id"
  end

  create_table "participants", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "scout_name"
    t.string "gender"
    t.date "birthdate"
    t.integer "pbs_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role"
    t.string "email", default: ""
    t.string "phone_number", default: ""
    t.index ["unit_id"], name: "index_participants_on_unit_id"
  end

  create_table "stufen", force: :cascade do |t|
    t.jsonb "name", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "code", null: false
    t.string "label", null: false
    t.string "icon", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transport_locations", force: :cascade do |t|
    t.string "name"
    t.integer "max_participants"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "units", force: :cascade do |t|
    t.integer "pbs_id"
    t.string "title"
    t.string "abteilung"
    t.integer "kv_id"
    t.string "stufe"
    t.integer "expected_participants_f"
    t.integer "expected_participants_m"
    t.integer "expected_participants_leitung_f"
    t.integer "expected_participants_leitung_m"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.bigint "lagerleiter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "limesurvey_token"
    t.bigint "al_id"
    t.bigint "coach_id"
    t.jsonb "midata_data"
    t.string "language"
    t.string "district"
    t.string "week"
    t.index ["al_id"], name: "index_units_on_al_id"
    t.index ["coach_id"], name: "index_units_on_coach_id"
    t.index ["lagerleiter_id"], name: "index_units_on_lagerleiter_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "pbs_id"
    t.integer "role_flags", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "activity_categories"
  add_foreign_key "activities", "transport_locations"
  add_foreign_key "invoice_parts", "invoices"
  add_foreign_key "invoices", "units"
  add_foreign_key "participant_units", "participants"
  add_foreign_key "participant_units", "units"
  add_foreign_key "units", "kvs", primary_key: "pbs_id"
  add_foreign_key "units", "leaders", column: "al_id"
  add_foreign_key "units", "leaders", column: "coach_id"
  add_foreign_key "units", "leaders", column: "lagerleiter_id"
end
