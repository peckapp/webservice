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

ActiveRecord::Schema.define(version: 20140822160604) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

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

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "announcements", force: true do |t|
    t.string   "title",                    limit: 100,                 null: false
    t.text     "announcement_description"
    t.integer  "institution_id",                                       null: false
    t.integer  "user_id"
    t.boolean  "public",                               default: false
    t.integer  "comment_count"
    t.boolean  "deleted",                              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "default_score",                        default: 0
    t.string   "category"
    t.integer  "poster_id"
  end

  add_index "announcements", ["institution_id"], name: "index_announcements_on_institution_id", using: :btree
  add_index "announcements", ["title"], name: "index_announcements_on_title", using: :btree
  add_index "announcements", ["user_id"], name: "index_announcements_on_user_id", using: :btree

  create_table "athletic_events", force: true do |t|
    t.integer  "institution_id",                                null: false
    t.integer  "athletic_team_id",                              null: false
    t.string   "opponent"
    t.float    "team_score",         limit: 24
    t.float    "opponent_score",     limit: 24
    t.string   "home_or_away"
    t.string   "location",                                      null: false
    t.string   "result"
    t.text     "note"
    t.datetime "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "scrape_resource_id"
    t.integer  "default_score",                 default: 0
    t.string   "title"
    t.string   "description"
    t.string   "url"
    t.boolean  "public",                        default: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "end_time"
  end

  add_index "athletic_events", ["athletic_team_id"], name: "index_athletic_events_on_athletic_team_id", using: :btree
  add_index "athletic_events", ["institution_id"], name: "index_athletic_events_on_institution_id", using: :btree
  add_index "athletic_events", ["location"], name: "index_athletic_events_on_location", using: :btree
  add_index "athletic_events", ["opponent"], name: "index_athletic_events_on_opponent", using: :btree
  add_index "athletic_events", ["start_time"], name: "index_athletic_events_on_start_time", using: :btree

  create_table "athletic_teams", force: true do |t|
    t.integer  "institution_id",               null: false
    t.string   "sport_name",                   null: false
    t.string   "gender",                       null: false
    t.string   "head_coach"
    t.string   "team_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscriber_count", default: 0
    t.string   "simple_name"
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
    t.integer  "circle_id",                      null: false
    t.integer  "user_id",                        null: false
    t.integer  "invited_by",                     null: false
    t.datetime "date_added"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id",                 null: false
    t.boolean  "accepted",       default: false
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "circles", ["circle_name"], name: "index_circles_on_circle_name", using: :btree
  add_index "circles", ["institution_id"], name: "index_circles_on_institution_id", using: :btree
  add_index "circles", ["user_id"], name: "index_circles_on_user_id", using: :btree

  create_table "clubs", force: true do |t|
    t.integer  "institution_id",               null: false
    t.string   "club_name",                    null: false
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscriber_count", default: 0
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
    t.integer  "institution_id"
  end

  create_table "crawl_seeds", force: true do |t|
    t.string   "info"
    t.string   "url"
    t.string   "regex"
    t.boolean  "active",         default: false
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_resources", force: true do |t|
    t.string   "info"
    t.string   "column_name",                      null: false
    t.integer  "resource_type_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "foreign_key",      default: false
  end

  create_table "departments", force: true do |t|
    t.string   "name",                         null: false
    t.integer  "institution_id",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscriber_count", default: 0
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
    t.integer  "institution_id",            null: false
    t.string   "name",                      null: false
    t.string   "details_link"
    t.float    "gps_longitude",  limit: 24
    t.float    "gps_latitude",   limit: 24
    t.float    "range",          limit: 24
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

  create_table "events_page_urls", force: true do |t|
    t.integer  "institution_id",       null: false
    t.string   "url",                  null: false
    t.string   "events_page_url_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events_page_urls", ["events_page_url_type"], name: "index_events_page_urls_on_events_page_url_type", using: :btree
  add_index "events_page_urls", ["institution_id"], name: "index_events_page_urls_on_institution_id", using: :btree

  create_table "follows", force: true do |t|
    t.string   "follower_type"
    t.integer  "follower_id"
    t.string   "followable_type"
    t.integer  "followable_id"
    t.datetime "created_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "institutions", force: true do |t|
    t.string   "name",                        null: false
    t.string   "street_address"
    t.string   "city",                        null: false
    t.string   "state",                       null: false
    t.string   "country",                     null: false
    t.float    "gps_longitude",    limit: 24
    t.float    "gps_latitude",     limit: 24
    t.float    "range",            limit: 24
    t.integer  "configuration_id"
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_regex"
    t.string   "time_zone"
  end

  add_index "institutions", ["configuration_id"], name: "index_institutions_on_configuration_id", using: :btree
  add_index "institutions", ["name"], name: "index_institutions_on_name", using: :btree

  create_table "inviters_users", id: false, force: true do |t|
    t.integer "event_attendee_id", null: false
    t.integer "user_id",           null: false
  end

  add_index "inviters_users", ["event_attendee_id", "user_id"], name: "index_inviters_users_on_event_attendee_id_and_user_id", using: :btree

  create_table "likes", force: true do |t|
    t.string   "liker_type"
    t.integer  "liker_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "fk_likeables", using: :btree
  add_index "likes", ["liker_id", "liker_type"], name: "fk_likes", using: :btree

  create_table "locations", force: true do |t|
    t.integer  "institution_id",            null: false
    t.string   "name",                      null: false
    t.float    "gps_longitude",  limit: 24
    t.float    "gps_latitude",   limit: 24
    t.float    "range",          limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["institution_id"], name: "index_locations_on_institution_id", using: :btree
  add_index "locations", ["name"], name: "index_locations_on_name", using: :btree

  create_table "mentions", force: true do |t|
    t.string   "mentioner_type"
    t.integer  "mentioner_id"
    t.string   "mentionable_type"
    t.integer  "mentionable_id"
    t.datetime "created_at"
  end

  add_index "mentions", ["mentionable_id", "mentionable_type"], name: "fk_mentionables", using: :btree
  add_index "mentions", ["mentioner_id", "mentioner_type"], name: "fk_mentions", using: :btree

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

  create_table "pecks", force: true do |t|
    t.integer  "user_id",                                null: false
    t.string   "notification_type",                      null: false
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id",                         null: false
    t.boolean  "send_push_notification", default: false
    t.integer  "invited_by"
    t.integer  "invitation"
    t.boolean  "interacted",             default: false
    t.integer  "refers_to"
  end

  add_index "pecks", ["notification_type"], name: "index_pecks_on_notification_type", using: :btree
  add_index "pecks", ["user_id"], name: "index_pecks_on_user_id", using: :btree

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

  create_table "resource_urls", force: true do |t|
    t.string   "url",                                null: false
    t.string   "info"
    t.integer  "scrape_resource_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "validated",          default: false
    t.string   "scraped_value"
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
    t.string   "url"
    t.integer  "institution_id",                         null: false
    t.integer  "scrape_interval",        default: 1440
    t.boolean  "validated",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "resource_type_id"
    t.integer  "pagination_selector_id"
    t.string   "info"
    t.string   "kind"
    t.string   "engine_type"
  end

  create_table "selectors", force: true do |t|
    t.string   "info"
    t.string   "selector",                                 null: false
    t.boolean  "top_level",                default: false
    t.integer  "parent_id"
    t.integer  "data_resource_id"
    t.integer  "scrape_resource_id",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "foreign_data_resource_id"
  end

  create_table "simple_events", force: true do |t|
    t.string   "title",              limit: 100,                 null: false
    t.text     "event_description"
    t.integer  "institution_id",                                 null: false
    t.integer  "user_id"
    t.string   "url"
    t.boolean  "public",                         default: false
    t.integer  "comment_count"
    t.datetime "start_date",                                     null: false
    t.datetime "end_date",                                       null: false
    t.boolean  "deleted",                        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude",           limit: 24
    t.float    "longitude",          limit: 24
    t.integer  "scrape_resource_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "category"
    t.integer  "organizer_id"
    t.integer  "default_score",                  default: 0
  end

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

  add_index "subscriptions", ["category"], name: "index_subscriptions_on_category", using: :btree
  add_index "subscriptions", ["institution_id"], name: "index_subscriptions_on_institution_id", using: :btree
  add_index "subscriptions", ["subscribed_to"], name: "index_subscriptions_on_subscribed_to", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "udid_users", force: true do |t|
    t.integer  "unique_device_identifier_id", null: false
    t.integer  "user_id",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "udid_users", ["unique_device_identifier_id", "user_id"], name: "user_device_tokens_users_index", using: :btree

  create_table "unique_device_identifiers", force: true do |t|
    t.string   "udid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "device_type"
  end

  create_table "unique_device_identifiers_users", id: false, force: true do |t|
    t.integer  "unique_device_identifier_id", null: false
    t.integer  "user_id",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unique_device_identifiers_users", ["unique_device_identifier_id", "user_id"], name: "user_device_tokens_users_index", using: :btree

  create_table "user_device_tokens", force: true do |t|
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_device_tokens_users", id: false, force: true do |t|
    t.integer  "user_device_token_id", null: false
    t.integer  "user_id",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_device_tokens_users", ["user_device_token_id", "user_id"], name: "user_device_tokens_users_index", using: :btree

  create_table "users", force: true do |t|
    t.integer  "institution_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "blurb"
    t.string   "facebook_link"
    t.string   "facebook_token"
    t.string   "password_hash"
    t.string   "api_key"
    t.boolean  "active",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
    t.string   "password_salt"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["institution_id"], name: "index_users_on_institution_id", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree

  create_table "views", force: true do |t|
    t.integer  "user_id",        null: false
    t.string   "category",       null: false
    t.integer  "content_id",     null: false
    t.datetime "date_viewed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institution_id", null: false
  end

  add_index "views", ["content_id"], name: "index_views_on_content_id", using: :btree
  add_index "views", ["user_id"], name: "index_views_on_user_id", using: :btree

end
