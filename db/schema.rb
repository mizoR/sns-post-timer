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

ActiveRecord::Schema.define(:version => 20120825052829) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id",       :null => false
    t.string   "service_type",  :null => false
    t.string   "uid",           :null => false
    t.string   "access_token",  :null => false
    t.string   "access_secret"
    t.datetime "expires_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "authentications", ["service_type", "access_token"], :name => "index_authentications_on_service_type_and_access_token", :unique => true
  add_index "authentications", ["service_type", "uid"], :name => "index_authentications_on_service_type_and_uid", :unique => true

  create_table "feeds", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "message",     :null => false
    t.string   "picture"
    t.string   "link"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "reserves", :force => true do |t|
    t.integer  "authentication_id",                :null => false
    t.integer  "feed_id",                          :null => false
    t.datetime "reserved_at",                      :null => false
    t.datetime "posts_at",                         :null => false
    t.datetime "posted_at"
    t.integer  "tried_times",       :default => 0, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",           :null => false
    t.string   "encrypted_password", :null => false
    t.string   "salt",               :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
