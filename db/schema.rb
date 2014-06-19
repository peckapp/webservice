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

ActiveRecord::Schema.define(version: 20140619184123) do

  create_table "circle_members", force: true do |t|
    t.integer  "circle_id",  null: false
    t.integer  "user_id",    null: false
    t.integer  "invited_by", null: false
    t.datetime "date_added"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "circle_members", ["circle_id"], name: "index_circle_members_on_circle_id", using: :btree
  add_index "circle_members", ["invited_by"], name: "index_circle_members_on_invited_by", using: :btree
  add_index "circle_members", ["user_id"], name: "index_circle_members_on_user_id", using: :btree

  create_table "circles", force: true do |t|
    t.integer  "institution_id", null: false
    t.integer  "user_id",        null: false
    t.string   "circle_name",    null: false
    t.string   "image_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "circles", ["circle_name"], name: "index_circles_on_circle_name", using: :btree
  add_index "circles", ["institution_id"], name: "index_circles_on_institution_id", using: :btree
  add_index "circles", ["user_id"], name: "index_circles_on_user_id", using: :btree

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

  create_table "dining_periods", force: true do |t|
    t.integer  "dining_place_id",       null: false
    t.integer  "dining_opportunity_id", null: false
    t.time     "start_time",            null: false
    t.time     "end_time",              null: false
    t.integer  "day_of_week"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dining_periods", ["dining_opportunity_id"], name: "index_dining_periods_on_dining_opportunity_id", using: :btree
  add_index "dining_periods", ["dining_place_id"], name: "index_dining_periods_on_dining_place_id", using: :btree

  create_table "dining_places", force: true do |t|
    t.integer  "institution_id", null: false
    t.string   "name",           null: false
    t.string   "details_link"
    t.float    "gps_longitude"
    t.float    "gps_latitude"
    t.float    "range"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dining_places", ["institution_id"], name: "index_dining_places_on_institution_id", using: :btree
  add_index "dining_places", ["name"], name: "index_dining_places_on_name", using: :btree

  create_table "event_members", force: true do |t|
    t.integer  "event_id",   null: false
    t.integer  "user_id",    null: false
    t.integer  "invited_by", null: false
    t.datetime "date_added"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_members", ["event_id"], name: "index_event_members_on_event_id", using: :btree
  add_index "event_members", ["invited_by"], name: "index_event_members_on_invited_by", using: :btree
  add_index "event_members", ["user_id"], name: "index_event_members_on_user_id", using: :btree

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

  create_table "menu_items", force: true do |t|
    t.integer  "institution_id",   null: false
    t.integer  "dining_place_id",  null: false
    t.integer  "dining_period_id"
    t.string   "details_link"
    t.string   "small_price"
    t.string   "large_price"
    t.string   "combo_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menu_items", ["dining_period_id"], name: "index_menu_items_on_dining_period_id", using: :btree
  add_index "menu_items", ["dining_place_id"], name: "index_menu_items_on_dining_place_id", using: :btree
  add_index "menu_items", ["institution_id"], name: "index_menu_items_on_institution_id", using: :btree

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
