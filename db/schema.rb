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

ActiveRecord::Schema.define(version: 20140715161348) do

  create_table "activity_logs", force: true do |t|
    t.integer  "sender",           null: false
    t.integer  "receiver",         null: false
    t.string   "category",         null: false
    t.integer  "from_event"
    t.integer  "circle_id"
    t.string   "type_of_activity", null: false
    t.string   "message",          null: false
    t.boolean  "read_status",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id",   null: false
  end

  add_index "activity_logs", ["circle_id"], name: "index_activity_logs_on_circle_id", using: :btree
  add_index "activity_logs", ["from_event"], name: "index_activity_logs_on_from_event", using: :btree
  add_index "activity_logs", ["receiver"], name: "index_activity_logs_on_receiver", using: :btree
  add_index "activity_logs", ["sender"], name: "index_activity_logs_on_sender", using: :btree
  add_index "activity_logs", ["type_of_activity"], name: "index_activity_logs_on_type_of_activity", using: :btree

  create_table "athletic_events", force: true do |t|
    t.integer  "institution_id",     null: false
    t.integer  "athletic_team_id",   null: false
    t.string   "opponent"
    t.float    "team_score"
    t.float    "opponent_score"
    t.string   "home_or_away"
    t.string   "location",           null: false
    t.string   "result"
    t.text     "note"
    t.datetime "date_and_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "scrape_resource_id"
  end

  add_index "athletic_events", ["athletic_team_id"], name: "index_athletic_events_on_athletic_team_id", using: :btree
  add_index "athletic_events", ["date_and_time"], name: "index_athletic_events_on_date_and_time", using: :btree
  add_index "athletic_events", ["institution_id"], name: "index_athletic_events_on_institution_id", using: :btree
  add_index "athletic_events", ["location"], name: "index_athletic_events_on_location", using: :btree
  add_index "athletic_events", ["opponent"], name: "index_athletic_events_on_opponent", using: :btree

  create_table "athletic_teams", force: true do |t|
    t.integer  "institution_id", null: false
    t.string   "sport_name",     null: false
    t.string   "gender",         null: false
    t.string   "head_coach"
    t.string   "team_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "athletic_teams", ["gender"], name: "index_athletic_teams_on_gender", using: :btree
  add_index "athletic_teams", ["institution_id"], name: "index_athletic_teams_on_institution_id", using: :btree
  add_index "athletic_teams", ["sport_name"], name: "index_athletic_teams_on_sport_name", using: :btree

  create_table "attendees_users", id: false, force: true do |t|
    t.integer "event_attendee_id", null: false
    t.integer "user_id",           null: false
  end

  add_index "attendees_users", ["event_attendee_id", "user_id"], name: "index_attendees_users_on_event_attendee_id_and_user_id", using: :btree

  create_table "circle_members", force: true do |t|
    t.integer  "circle_id",      null: false
    t.integer  "user_id",        null: false
    t.integer  "invited_by",     null: false
    t.datetime "date_added"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id", null: false
  end

  add_index "circle_members", ["circle_id"], name: "index_circle_members_on_circle_id", using: :btree
  add_index "circle_members", ["invited_by"], name: "index_circle_members_on_invited_by", using: :btree
  add_index "circle_members", ["user_id"], name: "index_circle_members_on_user_id", using: :btree

  create_table "circle_members_users", id: false, force: true do |t|
    t.integer "user_id",          null: false
    t.integer "circle_member_id", null: false
  end

  add_index "circle_members_users", ["user_id", "circle_member_id"], name: "circle_members_users_index", using: :btree

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

  create_table "clubs", force: true do |t|
    t.integer  "institution_id", null: false
    t.string   "club_name",      null: false
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clubs", ["club_name"], name: "index_clubs_on_club_name", using: :btree
  add_index "clubs", ["institution_id"], name: "index_clubs_on_institution_id", using: :btree
  add_index "clubs", ["user_id"], name: "index_clubs_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.string   "category",       null: false
    t.integer  "comment_from",   null: false
    t.integer  "user_id",        null: false
    t.text     "content",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id", null: false
  end

  add_index "comments", ["comment_from"], name: "index_comments_on_comment_from", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "configurations", force: true do |t|
    t.string   "mascot"
    t.string   "config_file_name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_resources", force: true do |t|
    t.string   "info"
    t.string   "column_name",      null: false
    t.integer  "resource_type_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name",           null: false
    t.integer  "institution_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments", ["institution_id"], name: "index_departments_on_institution_id", using: :btree
  add_index "departments", ["name"], name: "index_departments_on_name", using: :btree

  create_table "dining_opportunities", force: true do |t|
    t.string   "dining_opportunity_type", null: false
    t.integer  "institution_id",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dining_opportunities", ["dining_opportunity_type"], name: "index_dining_opportunities_on_dining_opportunity_type", using: :btree
  add_index "dining_opportunities", ["institution_id"], name: "index_dining_opportunities_on_institution_id", using: :btree

  create_table "dining_opportunities_dining_places", id: false, force: true do |t|
    t.integer "dining_opportunity_id", null: false
    t.integer "dining_place_id",       null: false
  end

  add_index "dining_opportunities_dining_places", ["dining_opportunity_id", "dining_place_id"], name: "dining_opportunities_dining_places_index", using: :btree

  create_table "dining_periods", force: true do |t|
    t.time     "start_time",            null: false
    t.time     "end_time",              null: false
    t.integer  "day_of_week"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dining_opportunity_id"
    t.integer  "dining_place_id"
    t.integer  "institution_id",        null: false
  end

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

  create_table "event_attendees", force: true do |t|
    t.integer  "user_id",        null: false
    t.integer  "added_by",       null: false
    t.string   "category",       null: false
    t.integer  "event_attended", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id", null: false
  end

  add_index "event_attendees", ["added_by"], name: "index_event_attendees_on_added_by", using: :btree
  add_index "event_attendees", ["event_attended"], name: "index_event_attendees_on_event_attended", using: :btree
  add_index "event_attendees", ["user_id"], name: "index_event_attendees_on_user_id", using: :btree

  create_table "event_views", force: true do |t|
    t.integer  "user_id",        null: false
    t.string   "category",       null: false
    t.integer  "event_viewed",   null: false
    t.datetime "date_viewed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id", null: false
  end

  add_index "event_views", ["event_viewed"], name: "index_event_views_on_event_viewed", using: :btree
  add_index "event_views", ["user_id"], name: "index_event_views_on_user_id", using: :btree

  create_table "events_page_urls", force: true do |t|
    t.integer  "institution_id",       null: false
    t.string   "url",                  null: false
    t.string   "events_page_url_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events_page_urls", ["events_page_url_type"], name: "index_events_page_urls_on_events_page_url_type", using: :btree
  add_index "events_page_urls", ["institution_id"], name: "index_events_page_urls_on_institution_id", using: :btree

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

  create_table "inviters_users", id: false, force: true do |t|
    t.integer "event_attendee_id", null: false
    t.integer "user_id",           null: false
  end

  add_index "inviters_users", ["event_attendee_id", "user_id"], name: "index_inviters_users_on_event_attendee_id_and_user_id", using: :btree

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
    t.string   "name",                  null: false
    t.integer  "institution_id",        null: false
    t.string   "details_link"
    t.string   "small_price"
    t.string   "large_price"
    t.string   "combo_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dining_opportunity_id"
    t.integer  "dining_place_id"
    t.date     "date_available",        null: false
    t.string   "category"
    t.string   "serving_size"
    t.integer  "scrape_resource_id"
  end

  add_index "menu_items", ["institution_id"], name: "index_menu_items_on_institution_id", using: :btree

  create_table "notification_views", force: true do |t|
    t.integer  "user_id",         null: false
    t.integer  "activity_log_id", null: false
    t.datetime "date_viewed"
    t.boolean  "viewed",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id",  null: false
  end

  add_index "notification_views", ["activity_log_id"], name: "index_notification_views_on_activity_log_id", using: :btree
  add_index "notification_views", ["user_id"], name: "index_notification_views_on_user_id", using: :btree

  create_table "push_notifications", force: true do |t|
    t.integer  "user_id",           null: false
    t.string   "notification_type", null: false
    t.string   "response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id",    null: false
  end

  add_index "push_notifications", ["notification_type"], name: "index_push_notifications_on_notification_type", using: :btree
  add_index "push_notifications", ["user_id"], name: "index_push_notifications_on_user_id", using: :btree

  create_table "resource_types", force: true do |t|
    t.string   "info"
    t.string   "resource_name", null: false
    t.string   "model_name",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rss_pages", force: true do |t|
    t.integer  "institution_id",                  null: false
    t.string   "url",                             null: false
    t.integer  "scrape_interval", default: 1440
    t.boolean  "paginated",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scrape_resources", force: true do |t|
    t.string   "url",                                    null: false
    t.integer  "institution_id",                         null: false
    t.integer  "scrape_interval",        default: 1440
    t.boolean  "validated",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "resource_type_id"
    t.integer  "pagination_selector_id"
  end

  create_table "selectors", force: true do |t|
    t.string   "info"
    t.string   "selector",                           null: false
    t.boolean  "top_level",          default: false
    t.integer  "parent_selector_id"
    t.integer  "data_resource_id",                   null: false
    t.integer  "scrape_resource_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_events", force: true do |t|
    t.string   "title",              limit: 100,                 null: false
    t.text     "event_description"
    t.integer  "institution_id",                                 null: false
    t.integer  "user_id"
    t.integer  "department_id"
    t.integer  "club_id"
    t.integer  "circle_id"
    t.string   "event_url"
    t.boolean  "open",                           default: false
    t.string   "image_url"
    t.integer  "comment_count"
    t.datetime "start_date",                                     null: false
    t.datetime "end_date",                                       null: false
    t.boolean  "deleted",                        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "scrape_resource_id"
  end

  add_index "simple_events", ["circle_id"], name: "index_simple_events_on_circle_id", using: :btree
  add_index "simple_events", ["club_id"], name: "index_simple_events_on_club_id", using: :btree
  add_index "simple_events", ["department_id"], name: "index_simple_events_on_department_id", using: :btree
  add_index "simple_events", ["institution_id"], name: "index_simple_events_on_institution_id", using: :btree
  add_index "simple_events", ["title"], name: "index_simple_events_on_title", using: :btree
  add_index "simple_events", ["user_id"], name: "index_simple_events_on_user_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id",        null: false
    t.string   "category",       null: false
    t.integer  "subscribed_to",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id", null: false
  end

  add_index "subscriptions", ["subscribed_to"], name: "index_subscriptions_on_subscribed_to", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "user_device_tokens", force: true do |t|
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id", null: false
  end

  create_table "user_device_tokens_users", id: false, force: true do |t|
    t.integer "user_device_token_id", null: false
    t.integer "user_id",              null: false
  end

  add_index "user_device_tokens_users", ["user_device_token_id", "user_id"], name: "user_device_tokens_users_index", using: :btree

  create_table "users", force: true do |t|
    t.integer  "institution_id",                       null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.text     "blurb"
    t.string   "facebook_link"
    t.string   "facebook_token"
    t.string   "password_digest"
    t.string   "api_key"
    t.boolean  "active",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
  end

  add_index "users", ["institution_id"], name: "index_users_on_institution_id", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
