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

ActiveRecord::Schema.define(:version => 20130315230039) do

  create_table "board_users", :force => true do |t|
    t.integer "updated_to"
    t.integer "board"
    t.integer "user_id"
    t.integer "last_reply"
  end

  create_table "boards", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "last_event"
    t.float    "order",      :default => 0.0,  :null => false
    t.integer  "last_post"
    t.integer  "last_yell"
    t.integer  "ppp",        :default => 50,   :null => false
    t.boolean  "visible",    :default => true, :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "owner"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "board"
    t.boolean  "pinned"
    t.integer  "post_type"
    t.integer  "reference"
    t.boolean  "yelled"
    t.boolean  "hidden"
  end

  create_table "sessions", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "user_agent"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "site_settings", :force => true do |t|
    t.boolean  "enable_mail"
    t.string   "smtp_server"
    t.integer  "smtp_port"
    t.string   "smtp_auth"
    t.string   "smtp_username"
    t.string   "smtp_password"
    t.boolean  "smtp_starttls_auto"
    t.string   "smtp_ssl_verify"
    t.string   "send_test_to"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "logo_text"
    t.string   "logo_image"
    t.boolean  "force_https"
    t.string   "mail_subject_prefix"
    t.string   "mail_from_address"
    t.integer  "initial_board"
    t.integer  "sitewide_event_board"
    t.string   "mail_from"
    t.integer  "last_merge_event"
    t.float    "min_update_interval",        :default => 4.0,  :null => false
    t.float    "max_update_interval",        :default => 32.0, :null => false
    t.string   "background_image"
    t.string   "background_gradient_top"
    t.string   "background_gradient_bottom"
    t.string   "navigation_text_color"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "visible_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "session"
    t.boolean  "is_confirmed"
    t.boolean  "can_edit_boards"
    t.boolean  "can_confirm_users"
    t.boolean  "can_edit_users"
    t.boolean  "can_edit_posts"
    t.boolean  "can_change_appearance"
    t.boolean  "can_change_site_settings"
    t.boolean  "can_mail_posts"
    t.boolean  "exiled"
  end

end
