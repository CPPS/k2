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

ActiveRecord::Schema.define(version: 20170218140821) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "server_id"
    t.integer  "account_id"
    t.integer  "solvedProblems"
    t.integer  "score"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["account_id", "server_id"], name: "index_accounts_on_account_id_and_server_id", unique: true, using: :btree
    t.index ["server_id"], name: "index_accounts_on_server_id", using: :btree
    t.index ["user_id", "server_id"], name: "index_accounts_on_user_id_and_server_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_accounts_on_user_id", using: :btree
  end

  create_table "problems", force: :cascade do |t|
    t.integer  "server_id"
    t.string   "problem_id"
    t.string   "short_name"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "label"
    t.index ["server_id", "problem_id"], name: "index_problems_on_server_id_and_problem_id", unique: true, using: :btree
    t.index ["server_id", "short_name"], name: "index_problems_on_server_id_and_short_name", unique: true, using: :btree
    t.index ["server_id"], name: "index_problems_on_server_id", using: :btree
  end

  create_table "servers", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "api_type"
    t.string   "api_endpoint"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "last_submission"
    t.integer  "started_at"
    t.integer  "contest_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "problem_id"
    t.integer  "account_id"
    t.integer  "submission_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "score"
    t.integer  "status",        default: 0
    t.string   "language"
    t.index ["account_id"], name: "index_submissions_on_account_id", using: :btree
    t.index ["problem_id", "submission_id"], name: "index_submissions_on_problem_id_and_submission_id", unique: true, using: :btree
    t.index ["problem_id"], name: "index_submissions_on_problem_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "webhooks", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "hook_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
