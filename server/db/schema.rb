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

ActiveRecord::Schema.define(version: 20171129201725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "dependencies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.string "raw"
    t.string "update_to"
    t.uuid "scan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scan_id"], name: "index_dependencies_on_scan_id"
  end

  create_table "exploits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "cves", default: [], array: true
    t.string "edb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "java_cves", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "date"
    t.string "desc"
    t.string "cvss2"
    t.string "cve_id"
    t.text "references"
    t.text "affected"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: false
    t.string "language"
    t.string "description"
    t.string "owner"
    t.integer "timeout", default: 3600
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "python_cves", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "date"
    t.string "desc"
    t.string "cvss2"
    t.string "cve_id"
    t.text "references"
    t.text "affected"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ruby_cves", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "dependency_name"
    t.string "date"
    t.string "desc"
    t.string "cvss2"
    t.string "cve_id"
    t.text "patched_versions", default: [], array: true
    t.text "unaffected_versions", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "date"
    t.string "source"
    t.string "needs_update"
    t.uuid "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_scans_on_project_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "dependencies", "scans"
  add_foreign_key "scans", "projects"
end
