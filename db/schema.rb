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

ActiveRecord::Schema.define(:version => 20131104020502) do

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "club_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "free"
    t.string   "image"
  end

  add_index "blogs", ["club_id"], :name => "index_blogs_on_club_id"

  create_table "clubs", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "logo"
    t.integer  "price_cents",    :default => 0,                       :null => false
    t.string   "price_currency", :default => "USD",                   :null => false
    t.integer  "user_id"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "sub_heading",    :default => "Club sub heading here"
  end

  add_index "clubs", ["user_id"], :name => "index_clubs_on_user_id"

  create_table "clubs_users", :force => true do |t|
    t.string   "level"
    t.integer  "user_id",                                  :null => false
    t.integer  "club_id",                                  :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "preapproval_key"
    t.string   "pro_status",       :default => "INACTIVE"
    t.string   "preapproval_uuid"
    t.date     "anniversary_date"
    t.string   "error"
  end

  add_index "clubs_users", ["club_id"], :name => "index_clubs_users_on_club_id"
  add_index "clubs_users", ["user_id"], :name => "index_clubs_users_on_user_id"

  create_table "courses", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "club_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "logo"
  end

  add_index "courses", ["club_id"], :name => "index_courses_on_club_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "discussion_boards", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "club_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "discussion_boards", ["club_id"], :name => "index_discussion_boards_on_club_id"

  create_table "lessons", :force => true do |t|
    t.string   "title"
    t.text     "background"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "free"
    t.string   "video"
  end

  add_index "lessons", ["course_id"], :name => "index_lessons_on_course_id"

  create_table "mercury_images", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "payments", :force => true do |t|
    t.string   "payer_email"
    t.string   "payee_email"
    t.string   "pay_key"
    t.integer  "total_amount_cents",    :default => 0,     :null => false
    t.string   "total_amount_currency", :default => "USD", :null => false
    t.integer  "payee_share_cents",     :default => 0,     :null => false
    t.string   "payee_share_currency",  :default => "USD", :null => false
    t.integer  "house_share_cents",     :default => 0,     :null => false
    t.string   "house_share_currency",  :default => "USD", :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "payments", ["payee_email"], :name => "index_payments_on_payee_email"
  add_index "payments", ["payer_email"], :name => "index_payments_on_payer_email"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "topic_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "posts", ["topic_id"], :name => "index_posts_on_topic_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "sales_pages", :force => true do |t|
    t.string   "heading"
    t.string   "sub_heading"
    t.string   "call_to_action"
    t.integer  "club_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "video"
    t.string   "benefit1"
    t.string   "benefit2"
    t.string   "benefit3"
  end

  create_table "topics", :force => true do |t|
    t.string   "subject"
    t.text     "description"
    t.integer  "discussion_board_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "user_id"
  end

  add_index "topics", ["discussion_board_id"], :name => "index_topics_on_discussion_board_id"
  add_index "topics", ["user_id"], :name => "index_topics_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                   :default => "",    :null => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 3
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.text     "description"
    t.string   "icon"
    t.boolean  "verified",               :default => false
    t.string   "payment_email"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
