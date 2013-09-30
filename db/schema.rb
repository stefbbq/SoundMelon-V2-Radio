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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130926160923) do

  create_table "artist_uploads", :force => true do |t|
    t.integer  "artist_id"
    t.string   "song_id"
    t.text     "keywords"
    t.boolean  "active",        :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "upload_source"
    t.string   "song_url"
    t.boolean  "is_private"
  end

  create_table "artists", :force => true do |t|
    t.string   "artist_name"
    t.integer  "user_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.text     "youtube_token"
    t.text     "soundcloud_token"
    t.string   "artist_photo_file_name"
    t.string   "artist_photo_content_type"
    t.integer  "artist_photo_file_size"
    t.datetime "artist_photo_updated_at"
    t.string   "website"
    t.text     "biography"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "email"
    t.string   "city"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "password_digest"
    t.string   "email_confirmation"
    t.string   "remember_token"
    t.boolean  "is_artist",          :default => false
    t.integer  "artist_id"
    t.text     "fb_meta"
    t.string   "provider"
    t.string   "uid"
    t.text     "oauth_token"
    t.boolean  "terms",              :default => false
    t.boolean  "custom_city",        :default => false
    t.text     "user_meta"
    t.text     "song_history"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
