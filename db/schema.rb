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

ActiveRecord::Schema.define(version: 2019_09_29_085706) do

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_branches_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "machines", force: :cascade do |t|
    t.string "name"
    t.string "type1"
    t.string "type2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orderers", force: :cascade do |t|
    t.integer "customer_id"
    t.string "family_name"
    t.string "first_name"
    t.string "phone_number"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orderers_on_customer_id"
  end

  create_table "orders", force: :cascade do |t|
    t.date "out_date"
    t.string "out_time"
    t.date "in_date"
    t.string "in_time"
    t.integer "status", limit: 1, default: 0, null: false
    t.integer "project_id"
    t.integer "orderer_id"
    t.integer "rental_machine_id"
    t.integer "user_id"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["orderer_id"], name: "index_orders_on_orderer_id"
    t.index ["project_id"], name: "index_orders_on_project_id"
    t.index ["rental_machine_id"], name: "index_orders_on_rental_machine_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "customer_id"
    t.string "name"
    t.string "address"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_projects_on_customer_id"
  end

  create_table "rental_machines", force: :cascade do |t|
    t.string "code"
    t.integer "machine_id"
    t.integer "branch_id"
    t.integer "storage_id"
    t.integer "status", limit: 1, default: 0, null: false
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_rental_machines_on_branch_id"
    t.index ["machine_id"], name: "index_rental_machines_on_machine_id"
    t.index ["storage_id"], name: "index_rental_machines_on_storage_id"
  end

  create_table "storages", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_storages_on_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
