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

ActiveRecord::Schema.define(version: 20171021193632) do

  create_table "cves", force: :cascade do |t|
    t.string "dependency_name"
    t.string "cve_id"
    t.string "date"
    t.string "desc"
    t.string "cvss2"
    t.string "patched_versions"
    t.string "unaffected_versions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dependencies", force: :cascade do |t|
    t.string "name"
    t.string "language"
    t.string "version"
    t.string "raw"
    t.integer "scan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scan_id"], name: "index_dependencies_on_scan_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.string "language"
    t.string "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scans", force: :cascade do |t|
    t.string "date"
    t.string "source"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_projects_on_scan_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
