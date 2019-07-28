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

ActiveRecord::Schema.define(version: 2019_07_28_021053) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
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

  create_table "expense_items", force: :cascade do |t|
    t.string "name"
    t.float "cost"
    t.datetime "expense_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "property_id"
    t.index ["property_id"], name: "index_expense_items_on_property_id"
  end

  create_table "lease_frequencies", force: :cascade do |t|
    t.string "frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lease_tenants", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "lease_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lease_id"], name: "index_lease_tenants_on_lease_id"
    t.index ["tenant_id"], name: "index_lease_tenants_on_tenant_id"
  end

  create_table "lease_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leases", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.jsonb "details"
    t.bigint "property_document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount"
    t.bigint "lease_frequency_id"
    t.bigint "property_id"
    t.bigint "lease_type_id"
    t.index ["lease_frequency_id"], name: "index_leases_on_lease_frequency_id"
    t.index ["lease_type_id"], name: "index_leases_on_lease_type_id"
    t.index ["property_document_id"], name: "index_leases_on_property_document_id"
    t.index ["property_id"], name: "index_leases_on_property_id"
  end

  create_table "properties", force: :cascade do |t|
    t.hstore "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "nickname"
    t.string "property_type"
    t.index ["property_type"], name: "index_properties_on_property_type"
    t.index ["user_id"], name: "index_properties_on_user_id"
  end

  create_table "property_document_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "property_documents", force: :cascade do |t|
    t.string "name"
    t.bigint "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "property_document_type_id"
    t.index ["property_document_type_id"], name: "index_property_documents_on_property_document_type_id"
    t.index ["property_id"], name: "index_property_documents_on_property_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
  end

  create_table "utility_accounts", force: :cascade do |t|
    t.string "name"
    t.jsonb "details"
    t.bigint "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_utility_accounts_on_property_id"
  end

  add_foreign_key "expense_items", "properties"
  add_foreign_key "lease_tenants", "leases"
  add_foreign_key "lease_tenants", "tenants"
  add_foreign_key "leases", "properties"
  add_foreign_key "leases", "property_documents"
  add_foreign_key "properties", "users"
  add_foreign_key "property_documents", "properties"
  add_foreign_key "utility_accounts", "properties"
end
