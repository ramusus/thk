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

ActiveRecord::Schema.define(:version => 20130321111959) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "subtitle"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "image_meta"
    t.string   "social_image_file_name"
    t.string   "social_image_content_type"
    t.integer  "social_image_file_size"
    t.datetime "social_image_updated_at"
    t.boolean  "main"
    t.boolean  "hide"
    t.boolean  "favorite"
    t.datetime "published_at"
    t.string   "title_seo"
    t.text     "right_column"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "articletype_id"
    t.text     "content"
    t.string   "url",                       :default => ""
  end

  create_table "articletypes", :force => true do |t|
    t.string   "name"
    t.string   "name_plural"
    t.string   "slug",        :default => ""
    t.string   "title",       :default => ""
    t.boolean  "filter_hide", :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "championships", :force => true do |t|
    t.string   "name"
    t.boolean  "archive"
    t.string   "link"
    t.datetime "last_game_date"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "chunks", :force => true do |t|
    t.string   "title"
    t.string   "code"
    t.text     "content"
    t.boolean  "visible",    :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "games", :force => true do |t|
    t.string   "rival"
    t.integer  "team_id"
    t.boolean  "home"
    t.integer  "score_host"
    t.integer  "score_guest"
    t.integer  "finished", :default => 0
    t.datetime "date"
    t.integer  "championship_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "slug"
    t.boolean  "visible",    :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "position"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.integer  "number"
    t.boolean  "temporary"
    t.integer  "goals"
    t.integer  "efficiency"
    t.integer  "fouls"
    t.integer  "height"
    t.integer  "weight"
    t.integer  "birthyear"
    t.integer  "experience"
    t.string   "position"
    t.text     "description"
    t.integer  "team_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "occupation"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "slides", :force => true do |t|
    t.integer  "position"
    t.string   "color"
    t.string   "background_color"
    t.text     "content"
    t.string   "link"
    t.boolean  "hide"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.text   "people_statistic"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
