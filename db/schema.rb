# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_05_21_133824) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appeals", force: :cascade do |t|
    t.bigint "claim_id"
    t.bigint "victim_id"
    t.integer "status"
    t.bigint "assigned_to_id"
    t.string "file_uid"
    t.string "bank_account"
    t.integer "payment_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount", precision: 15, scale: 3
    t.bigint "offender_id"
    t.datetime "deleted_at"
    t.index ["assigned_to_id"], name: "index_appeals_on_assigned_to_id"
    t.index ["claim_id"], name: "index_appeals_on_claim_id"
    t.index ["deleted_at"], name: "index_appeals_on_deleted_at"
    t.index ["offender_id"], name: "index_appeals_on_offender_id"
    t.index ["victim_id"], name: "index_appeals_on_victim_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "claims", force: :cascade do |t|
    t.string "file_uid"
    t.string "court_uid"
    t.datetime "binding_effect"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_claims_on_deleted_at"
  end

  create_table "debts", force: :cascade do |t|
    t.bigint "claim_id"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "offender_id"
    t.integer "debt_type", default: 1
    t.datetime "deleted_at"
    t.index ["claim_id"], name: "index_debts_on_claim_id"
    t.index ["deleted_at"], name: "index_debts_on_deleted_at"
    t.index ["offender_id"], name: "index_debts_on_offender_id"
  end

  create_table "egov_utils_addresses", id: :serial, force: :cascade do |t|
    t.integer "egov_identifier"
    t.string "street"
    t.string "house_number"
    t.string "orientation_number"
    t.string "city"
    t.string "city_part"
    t.string "postcode"
    t.string "district"
    t.string "region"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "egov_utils_groups", force: :cascade do |t|
    t.string "name"
    t.string "provider"
    t.string "roles"
    t.string "ldap_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_uid"
    t.string "organization_key"
    t.index ["organization_key"], name: "index_egov_utils_groups_on_organization_key"
  end

  create_table "egov_utils_groups_users", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "user_id"
    t.index ["group_id"], name: "index_egov_utils_groups_users_on_group_id"
    t.index ["user_id"], name: "index_egov_utils_groups_users_on_user_id"
  end

  create_table "egov_utils_legal_people", force: :cascade do |t|
    t.bigint "person_id"
    t.string "name"
    t.string "ico"
    t.integer "legal_form"
    t.index ["person_id"], name: "index_egov_utils_legal_people_on_person_id"
  end

  create_table "egov_utils_natural_people", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.date "birth_date"
    t.string "external_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "birth_place"
    t.bigint "person_id"
    t.string "title"
    t.string "higher_title"
    t.index ["person_id"], name: "index_egov_utils_natural_people_on_person_id"
  end

  create_table "egov_utils_people", force: :cascade do |t|
    t.integer "person_type"
    t.string "joid"
    t.bigint "residence_id"
    t.index ["residence_id"], name: "index_egov_utils_people_on_residence_id"
  end

  create_table "egov_utils_users", id: :serial, force: :cascade do |t|
    t.string "login"
    t.string "mail"
    t.string "password_digest"
    t.string "firstname"
    t.string "lastname"
    t.boolean "active", default: false
    t.string "roles"
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "confirmation_code"
    t.boolean "must_change_password"
    t.datetime "password_changed_at"
  end

  create_table "offenders", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "claim_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_id"], name: "index_offenders_on_claim_id"
    t.index ["person_id"], name: "index_offenders_on_person_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "status"
    t.string "payment_uid"
    t.decimal "value", precision: 15, scale: 3
    t.integer "direction"
    t.integer "currency_code"
    t.decimal "currency_value", precision: 15, scale: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.datetime "deleted_at"
    t.datetime "paid_at"
    t.index ["deleted_at"], name: "index_payments_on_deleted_at"
  end

  create_table "redemptions", force: :cascade do |t|
    t.bigint "payment_id"
    t.bigint "debt_id"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["author_id"], name: "index_redemptions_on_author_id"
    t.index ["debt_id"], name: "index_redemptions_on_debt_id"
    t.index ["deleted_at"], name: "index_redemptions_on_deleted_at"
    t.index ["payment_id"], name: "index_redemptions_on_payment_id"
  end

  create_table "satisfactions", force: :cascade do |t|
    t.bigint "payment_id"
    t.bigint "appeal_id"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["appeal_id"], name: "index_satisfactions_on_appeal_id"
    t.index ["author_id"], name: "index_satisfactions_on_author_id"
    t.index ["deleted_at"], name: "index_satisfactions_on_deleted_at"
    t.index ["payment_id"], name: "index_satisfactions_on_payment_id"
  end

  add_foreign_key "appeals", "claims"
  add_foreign_key "appeals", "egov_utils_people", column: "victim_id"
  add_foreign_key "appeals", "egov_utils_users", column: "assigned_to_id"
  add_foreign_key "appeals", "offenders"
  add_foreign_key "debts", "claims"
  add_foreign_key "debts", "offenders"
  add_foreign_key "egov_utils_groups_users", "egov_utils_groups", column: "group_id"
  add_foreign_key "egov_utils_groups_users", "egov_utils_users", column: "user_id"
  add_foreign_key "egov_utils_legal_people", "egov_utils_people", column: "person_id"
  add_foreign_key "egov_utils_natural_people", "egov_utils_people", column: "person_id"
  add_foreign_key "egov_utils_people", "egov_utils_addresses", column: "residence_id"
  add_foreign_key "offenders", "claims"
  add_foreign_key "offenders", "egov_utils_people", column: "person_id"
  add_foreign_key "redemptions", "debts"
  add_foreign_key "redemptions", "egov_utils_users", column: "author_id"
  add_foreign_key "redemptions", "payments"
  add_foreign_key "satisfactions", "appeals"
  add_foreign_key "satisfactions", "egov_utils_users", column: "author_id"
  add_foreign_key "satisfactions", "payments"
end
