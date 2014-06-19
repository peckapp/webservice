# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140619174757) do

  create_table "configurations", force: true do |t|
    t.integer  "institution_id",   null: false
    t.string   "mascot"
    t.string   "config_file_name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "configurations", ["institution_id"], name: "index_configurations_on_institution_id", using: :btree

  create_table "departments", force: true do |t|
    t.string   "name",           null: false
    t.integer  "institution_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments", ["institution_id"], name: "index_departments_on_institution_id", using: :btree
  add_index "departments", ["name"], name: "index_departments_on_name", using: :btree

  create_table "events", force: true do |t|
    t.string   "title",             limit: 100,                 null: false
    t.text     "event_description"
    t.integer  "institution_id",                                null: false
    t.integer  "user_id"
    t.integer  "department_id"
    t.integer  "club_id"
    t.boolean  "open",                          default: false
    t.string   "image_url"
    t.integer  "circle_id"
    t.integer  "comment_count"
    t.datetime "start_date",                                    null: false
    t.datetime "end_date",                                      null: false
    t.boolean  "deleted",                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["circle_id"], name: "index_events_on_circle_id", using: :btree
  add_index "events", ["club_id"], name: "index_events_on_club_id", using: :btree
  add_index "events", ["department_id"], name: "index_events_on_department_id", using: :btree
  add_index "events", ["institution_id"], name: "index_events_on_institution_id", using: :btree
  add_index "events", ["title"], name: "index_events_on_title", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "institutions", force: true do |t|
    t.string   "name",             null: false
    t.string   "street_address",   null: false
    t.string   "city",             null: false
    t.string   "state",            null: false
    t.string   "country",          null: false
    t.float    "gps_longitude",    null: false
    t.float    "gps_latitude",     null: false
    t.float    "range",            null: false
    t.integer  "configuration_id", null: false
    t.string   "api_key",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "institutions", ["configuration_id"], name: "index_institutions_on_configuration_id", using: :btree
  add_index "institutions", ["name"], name: "index_institutions_on_name", using: :btree

  create_table "locations", force: true do |t|
    t.integer  "institution_id", null: false
    t.string   "name",           null: false
    t.float    "gps_longitude"
    t.float    "gps_latitude"
    t.float    "range"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["institution_id"], name: "index_locations_on_institution_id", using: :btree
  add_index "locations", ["name"], name: "index_locations_on_name", using: :btree

  create_table "users", force: true do |t|
    t.integer  "institution_id",                  null: false
    t.string   "first_name",                      null: false
    t.string   "last_name",                       null: false
    t.string   "username",                        null: false
    t.text     "blurb"
    t.string   "facebook_link"
    t.string   "facebook_token"
    t.string   "password_digest"
    t.string   "api_key",                         null: false
    t.boolean  "active",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["institution_id"], name: "index_users_on_institution_id", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
