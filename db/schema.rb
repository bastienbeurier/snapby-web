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

ActiveRecord::Schema.define(version: 20140124112208) do

  create_table "black_listed_devices", force: true do |t|
    t.string   "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "shout_id"
    t.integer  "shouter_id"
    t.integer  "commenter_id"
    t.string   "commenter_username"
    t.string   "description"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["shout_id"], name: "index_comments_on_shout_id", using: :btree

  create_table "devices", force: true do |t|
    t.string   "device_id"
    t.string   "push_token"
    t.float    "lat"
    t.float    "lng"
    t.integer  "notification_radius"
    t.string   "device_model"
    t.string   "os_version"
    t.string   "os_type"
    t.string   "app_version"
    t.string   "api_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["device_id"], name: "index_devices_on_device_id", unique: true, using: :btree

  create_table "flagged_shouts", force: true do |t|
    t.integer  "shout_id"
    t.string   "motive"
    t.string   "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_ids"
  end

  create_table "flags", force: true do |t|
    t.integer "shout_id"
    t.string  "motive"
    t.integer "flagger_id"
  end

  create_table "likes", force: true do |t|
    t.integer  "shout_id"
    t.integer  "liker_id"
    t.string   "liker_username"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["shout_id"], name: "index_likes_on_shout_id", using: :btree

  create_table "removed_shouts", force: true do |t|
    t.integer  "shout_id"
    t.float    "lat"
    t.float    "lng"
    t.string   "description"
    t.string   "display_name"
    t.string   "source"
    t.string   "device_id"
    t.string   "image"
    t.string   "removed_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "shout_created_at"
    t.integer  "user_id"
  end

  create_table "scheduled_shouts", force: true do |t|
    t.float    "lat"
    t.float    "lng"
    t.datetime "scheduled_time"
    t.string   "description"
    t.string   "display_name"
    t.string   "image"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "is_born",             default: false
  end

  create_table "shouts", force: true do |t|
    t.float    "lat"
    t.float    "lng"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
    t.string   "source"
    t.string   "device_id"
    t.string   "image"
    t.integer  "user_id"
    t.string   "username"
    t.boolean  "removed",      default: false
  end

  create_table "user_notifications", force: true do |t|
    t.integer  "user_id"
    t.integer  "sent_count"
    t.datetime "last_sent"
    t.integer  "blocked_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.float    "lat"
    t.float    "lng"
    t.integer  "notification_radius"
    t.string   "device_model"
    t.string   "os_version"
    t.string   "os_type"
    t.string   "app_version"
    t.string   "api_version"
    t.string   "push_token"
    t.string   "facebook_id"
    t.string   "facebook_name"
    t.boolean  "black_listed",           default: false
    t.string   "profile_picture"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
