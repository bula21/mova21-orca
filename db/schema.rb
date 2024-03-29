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

ActiveRecord::Schema.define(version: 2022_07_29_111402) do

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
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
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
    t.integer "rover_shift_prio"
    t.integer "rover_job_id"
    t.integer "required_rovers"
    t.index ["activity_category_id"], name: "index_activities_on_activity_category_id"
    t.index ["transport_location_id"], name: "index_activities_on_transport_location_id"
  end

  create_table "activities_goals", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "goal_id", null: false
    t.index ["activity_id", "goal_id"], name: "index_activities_goals_on_activity_id_and_goal_id", unique: true
    t.index ["goal_id", "activity_id"], name: "index_activities_goals_on_goal_id_and_activity_id"
  end

  create_table "activities_stufen", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "stufe_id", null: false
    t.index ["activity_id", "stufe_id"], name: "index_activities_stufen_on_activity_id_and_stufe_id", unique: true
    t.index ["stufe_id", "activity_id"], name: "index_activities_stufen_on_stufe_id_and_activity_id"
  end

  create_table "activities_stufen_recommended", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "stufe_id", null: false
    t.index ["activity_id", "stufe_id"], name: "unique_activities_stufen_recommended_index", unique: true
    t.index ["stufe_id", "activity_id"], name: "index_stufen_recommended_activities_index"
  end

  create_table "activities_tags", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "tag_id", null: false
    t.index ["activity_id", "tag_id"], name: "index_activities_tags_on_activity_id_and_tag_id", unique: true
    t.index ["tag_id", "activity_id"], name: "index_activities_tags_on_tag_id_and_activity_id"
  end

  create_table "activity_categories", force: :cascade do |t|
    t.jsonb "label", default: {}
    t.string "ancestry"
    t.string "code"
    t.index ["ancestry"], name: "index_activity_categories_on_ancestry"
  end

  create_table "activity_execution_rover_shifts", force: :cascade do |t|
    t.bigint "activity_execution_id"
    t.bigint "rover_shift_id"
    t.index ["activity_execution_id"], name: "index_activity_execution_rover_shifts_on_activity_execution_id"
    t.index ["rover_shift_id"], name: "index_activity_execution_rover_shifts_on_rover_shift_id"
  end

  create_table "activity_executions", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer "language_flags"
    t.integer "amount_participants"
    t.integer "field_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "transport"
    t.boolean "mixed_languages"
    t.string "transport_ids"
    t.index ["activity_id"], name: "index_activity_executions_on_activity_id"
    t.index ["field_id"], name: "index_activity_executions_on_field_id"
  end

  create_table "checkpoint_units", force: :cascade do |t|
    t.bigint "checkpoint_id", null: false
    t.bigint "unit_id", null: false
    t.text "notes_check_in"
    t.boolean "checked_in_on_paper", default: false
    t.bigint "check_in_by_id"
    t.datetime "confirmed_checked_in_at"
    t.bigint "confirmed_check_in_by_id"
    t.text "notes_check_out"
    t.boolean "check_out_ok"
    t.float "cost_in_chf"
    t.datetime "checked_out_at"
    t.bigint "check_out_by_id"
    t.boolean "checked_out_on_paper", default: false
    t.datetime "confirmed_checked_out_at"
    t.bigint "confirmed_check_out_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "checked_in_at"
    t.index ["check_in_by_id"], name: "index_checkpoint_units_on_check_in_by_id"
    t.index ["check_out_by_id"], name: "index_checkpoint_units_on_check_out_by_id"
    t.index ["checkpoint_id", "unit_id"], name: "index_checkpoint_units_on_checkpoint_id_and_unit_id", unique: true
    t.index ["checkpoint_id"], name: "index_checkpoint_units_on_checkpoint_id"
    t.index ["confirmed_check_in_by_id"], name: "index_checkpoint_units_on_confirmed_check_in_by_id"
    t.index ["confirmed_check_out_by_id"], name: "index_checkpoint_units_on_confirmed_check_out_by_id"
    t.index ["unit_id"], name: "index_checkpoint_units_on_unit_id"
  end

  create_table "checkpoints", force: :cascade do |t|
    t.string "slug", null: false
    t.json "title", default: {}
    t.json "description_check_in", default: {}
    t.json "description_check_out", default: {}
    t.bigint "depends_on_checkpoint_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["depends_on_checkpoint_id"], name: "index_checkpoints_on_depends_on_checkpoint_id"
  end

  create_table "fields", force: :cascade do |t|
    t.string "name_untranslated"
    t.integer "spot_id", null: false
    t.jsonb "name", default: {}
    t.index ["spot_id"], name: "index_fields_on_spot_id"
  end

  create_table "fixed_events", force: :cascade do |t|
    t.jsonb "title", default: {}
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "fixed_events_stufen", force: :cascade do |t|
    t.integer "fixed_event_id", null: false
    t.integer "stufe_id", null: false
    t.index ["fixed_event_id"], name: "index_fixed_events_stufen_on_fixed_event_id"
    t.index ["stufe_id"], name: "index_fixed_events_stufen_on_stufe_id"
  end

  create_table "goals", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "name", default: {}
  end

  create_table "invoice_parts", force: :cascade do |t|
    t.integer "invoice_id", null: false
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
    t.integer "unit_id", null: false
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
    t.boolean "generated", default: true
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
    t.integer "translatable_id"
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
    t.integer "translatable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_text_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_text_translations_on_keys", unique: true
  end

  create_table "participant_search_logs", force: :cascade do |t|
    t.bigint "user_id"
    t.text "search_query"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_participant_search_logs_on_user_id"
  end

  create_table "participant_units", force: :cascade do |t|
    t.integer "unit_id", null: false
    t.integer "participant_id", null: false
    t.string "role"
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
    t.string "guest_troop"
  end

  create_table "rover_shifts", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string "place"
    t.integer "job_id"
    t.jsonb "rovers"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "spots", force: :cascade do |t|
    t.string "name_untranslated"
    t.string "color"
    t.jsonb "name", default: {}
  end

  create_table "stufen", force: :cascade do |t|
    t.jsonb "name", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.integer "root_camp_unit_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "code", null: false
    t.string "label_untranslated"
    t.string "icon", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "label", default: {}
  end

  create_table "transport_locations", force: :cascade do |t|
    t.string "name"
    t.integer "max_participants"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "unit_activities", force: :cascade do |t|
    t.integer "unit_id", null: false
    t.integer "activity_id", null: false
    t.integer "priority"
    t.text "remarks"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_unit_activities_on_activity_id"
    t.index ["priority"], name: "index_unit_activities_on_priority"
    t.index ["unit_id"], name: "index_unit_activities_on_unit_id"
  end

  create_table "unit_activity_executions", force: :cascade do |t|
    t.integer "unit_id", null: false
    t.integer "activity_execution_id", null: false
    t.integer "headcount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "additional_data"
    t.index ["activity_execution_id"], name: "index_unit_activity_executions_on_activity_execution_id"
    t.index ["unit_id"], name: "index_unit_activity_executions_on_unit_id"
  end

  create_table "unit_contact_logs", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "unit_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["unit_id"], name: "index_unit_contact_logs_on_unit_id"
    t.index ["user_id"], name: "index_unit_contact_logs_on_user_id"
  end

  create_table "unit_program_changes", force: :cascade do |t|
    t.bigint "unit_id", null: false
    t.bigint "activity_execution_id"
    t.bigint "unit_activity_execution_id"
    t.boolean "notified_at"
    t.text "remarks"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_execution_id"], name: "index_unit_program_changes_on_activity_execution_id"
    t.index ["unit_activity_execution_id"], name: "index_unit_program_changes_on_unit_activity_execution_id"
    t.index ["unit_id"], name: "index_unit_program_changes_on_unit_id"
  end

  create_table "unit_visitor_days", force: :cascade do |t|
    t.integer "unit_id", null: false
    t.integer "u6_tickets", default: 0, null: false
    t.integer "u16_tickets", default: 0, null: false
    t.integer "u16_ga_tickets", default: 0, null: false
    t.integer "ga_tickets", default: 0, null: false
    t.integer "other_tickets", default: 0, null: false
    t.text "responsible_address"
    t.string "responsible_email"
    t.string "responsible_phone"
    t.integer "phase", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "responsible_lastname"
    t.string "responsible_firstname"
    t.string "responsible_place"
    t.string "responsible_postal_code"
    t.string "responsible_salutation"
    t.boolean "ltb_accepted"
    t.index ["unit_id"], name: "index_unit_visitor_days_on_unit_id"
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
    t.integer "lagerleiter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "limesurvey_token"
    t.bigint "al_id"
    t.bigint "coach_id"
    t.jsonb "midata_data"
    t.string "language"
    t.string "district"
    t.string "week"
    t.integer "activity_booking_phase", default: 0
    t.bigint "stufe_id"
    t.integer "expected_guest_participants"
    t.integer "expected_guest_leaders"
    t.integer "visitor_day_tickets", default: 0
    t.string "food_pickup_slot"
    t.integer "definite_max_number_of_persons"
    t.integer "amount_of_rovers"
    t.string "arrival_slot"
    t.string "departure_slot"
    t.datetime "hand_over_camp_at"
    t.string "transport_mode"
    t.datetime "accept_security_concept_at"
    t.integer "district_number"
    t.string "kitchen_id"
    t.string "contact_phonenumber_1"
    t.string "contact_phonenumber_2"
    t.index ["al_id"], name: "index_units_on_al_id"
    t.index ["coach_id"], name: "index_units_on_coach_id"
    t.index ["lagerleiter_id"], name: "index_units_on_lagerleiter_id"
    t.index ["stufe_id"], name: "index_units_on_stufe_id"
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

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "activity_categories"
  add_foreign_key "activities", "transport_locations"
  add_foreign_key "activity_execution_rover_shifts", "activity_executions"
  add_foreign_key "activity_execution_rover_shifts", "rover_shifts"
  add_foreign_key "activity_executions", "activities"
  add_foreign_key "activity_executions", "fields"
  add_foreign_key "checkpoint_units", "checkpoints"
  add_foreign_key "checkpoint_units", "units"
  add_foreign_key "checkpoint_units", "users", column: "check_in_by_id"
  add_foreign_key "checkpoint_units", "users", column: "check_out_by_id"
  add_foreign_key "checkpoint_units", "users", column: "confirmed_check_in_by_id"
  add_foreign_key "checkpoint_units", "users", column: "confirmed_check_out_by_id"
  add_foreign_key "checkpoints", "checkpoints", column: "depends_on_checkpoint_id"
  add_foreign_key "fields", "spots"
  add_foreign_key "fixed_events_stufen", "fixed_events"
  add_foreign_key "fixed_events_stufen", "stufen"
  add_foreign_key "invoice_parts", "invoices"
  add_foreign_key "invoices", "units"
  add_foreign_key "participant_units", "participants"
  add_foreign_key "participant_units", "units"
  add_foreign_key "unit_activities", "activities"
  add_foreign_key "unit_activities", "units"
  add_foreign_key "unit_activity_executions", "activity_executions"
  add_foreign_key "unit_activity_executions", "units"
  add_foreign_key "unit_program_changes", "activity_executions"
  add_foreign_key "unit_program_changes", "unit_activity_executions"
  add_foreign_key "unit_program_changes", "units"
  add_foreign_key "unit_visitor_days", "units"
  add_foreign_key "units", "kvs", primary_key: "pbs_id"
  add_foreign_key "units", "leaders", column: "al_id"
  add_foreign_key "units", "leaders", column: "coach_id"
  add_foreign_key "units", "leaders", column: "lagerleiter_id"
  add_foreign_key "units", "stufen"
end
