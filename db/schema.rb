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

ActiveRecord::Schema.define(version: 20150630061858) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bid_lines", force: :cascade do |t|
    t.json     "lines"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "employees", ["email"], name: "index_employees_on_email", unique: true, using: :btree
  add_index "employees", ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true, using: :btree

  create_table "news_feeds", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "news_feeds", ["profile_id"], name: "index_news_feeds_on_profile_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "profile_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "posts", ["profile_id"], name: "index_posts_on_profile_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "fname"
    t.string   "lname"
    t.integer  "bid_line"
    t.integer  "employee_id"
    t.integer  "emp_num"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "profiles", ["employee_id"], name: "index_profiles_on_employee_id", using: :btree

  create_table "shifts", force: :cascade do |t|
    t.string   "position"
    t.date     "date"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.string   "scheduled"
    t.integer  "profile_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "description"
    t.integer  "original_owner"
    t.boolean  "posted",           default: false, null: false
    t.boolean  "partial",          default: false, null: false
    t.boolean  "available",        default: false, null: false
    t.string   "period_available", default: "f"
    t.string   "type"
    t.integer  "post_id",          default: 0
    t.integer  "collegue_id",      default: 0
  end

  add_index "shifts", ["profile_id"], name: "index_shifts_on_profile_id", using: :btree

  add_foreign_key "news_feeds", "profiles"
  add_foreign_key "posts", "profiles"
  add_foreign_key "profiles", "employees"
  add_foreign_key "shifts", "profiles"
end
