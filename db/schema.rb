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

ActiveRecord::Schema.define(version: 2021_01_21_074133) do

  create_table "apps", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.string "plants"
    t.string "last_version"
    t.integer "last_pkg_size"
    t.integer "last_pkg_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "desc"
    t.integer "palts_count", default: 0
    t.integer "packages_count", default: 0
    t.integer "user_id"
    t.datetime "deleted_at"
    t.boolean "archived", default: false
    t.index ["deleted_at"], name: "index_apps_on_deleted_at"
  end

  create_table "pkgs", force: :cascade do |t|
    t.integer "app_id"
    t.string "name"
    t.string "icon"
    t.string "plat_name"
    t.string "bundle_id"
    t.string "version"
    t.string "build"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plat_id"
    t.string "file"
    t.integer "size", default: 0
    t.string "uniq_key"
    t.integer "user_id"
    t.datetime "deleted_at"
    t.string "file_nick_name"
    t.string "features"
    t.string "ext_info"
    t.index ["deleted_at"], name: "index_pkgs_on_deleted_at"
  end

  create_table "plats", force: :cascade do |t|
    t.string "name"
    t.string "plat_name"
    t.integer "app_id"
    t.string "pkg_name"
    t.integer "packages_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bundle_id"
    t.boolean "pkg_uniq", default: true
    t.integer "user_id"
    t.datetime "deleted_at"
    t.integer "sort", default: 0
    t.index ["deleted_at"], name: "index_plats_on_deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "role", default: "user"
    t.string "password_digest"
    t.string "remember_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_token"
    t.datetime "deleted_at"
    t.index ["api_token"], name: "index_users_on_api_token"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

end
