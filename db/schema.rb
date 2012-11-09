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

ActiveRecord::Schema.define(:version => 20121109191142) do

  create_table "posts", :force => true do |t|
    t.integer  "owner"
    t.text     "content",    :limit => 255
    t.datetime "post_date"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "topic"
    t.boolean  "pinned"
    t.integer  "type"
    t.integer  "reference"
  end

  create_table "topic_users", :force => true do |t|
    t.integer "updated_to"
    t.integer "topic"
    t.integer "user"
  end

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "last_activity"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "visible_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "session"
    t.boolean  "is_confirmed"
    t.boolean  "can_edit_topics"
    t.boolean  "can_confirm_users"
    t.boolean  "can_edit_users"
    t.boolean  "can_edit_posts"
  end

end
