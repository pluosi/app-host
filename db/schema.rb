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

ActiveRecord::Schema.define(version: 20170801085510) do

  create_table "apps", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.string "plants"
    t.string "last_version"
    t.integer "last_pkg_size"
    t.integer "last_pkg_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "packages", force: :cascade do |t|
    t.integer "app_id"
    t.string "name"
    t.string "icon"
    t.string "plat"
    t.string "ident"
    t.string "version"
    t.string "build"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
