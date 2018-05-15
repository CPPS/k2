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

ActiveRecord::Schema.define(version: 20180515210825) do

  create_table "accounts", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.integer "user_id"
    t.integer "server_id"
    t.integer "account_id"
    t.integer "solvedProblems"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "rank_changed_at", default: "1970-01-01 00:00:00"
    t.integer "prev_rank", default: 2000000000
    t.integer "rank_delta", default: 0
    t.index ["account_id", "server_id"], name: "index_accounts_on_account_id_and_server_id", unique: true
    t.index ["id"], name: "id", unique: true
    t.index ["server_id"], name: "index_accounts_on_server_id"
    t.index ["user_id", "server_id"], name: "index_accounts_on_user_id_and_server_id", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "achievement_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "title"
    t.string "description"
    t.string "variable"
    t.string "comparison"
    t.integer "value"
    t.string "img_small"
    t.string "img_large"
    t.integer "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "achievements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.datetime "date_of_completion"
    t.integer "prev_rank", default: 2000000000
    t.boolean "isActive", default: true
    t.integer "achievement_datum_id"
    t.index ["achievement_datum_id"], name: "index_achievements_on_achievement_datum_id"
    t.index ["user_id"], name: "index_achievements_on_user_id"
  end

  create_table "level_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer "achievement_datum_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_datum_id"], name: "index_level_entries_on_achievement_datum_id"
  end

  create_table "prereq_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer "achievement_datum_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_datum_id"], name: "index_prereq_entries_on_achievement_datum_id"
  end

  create_table "problem_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer "achievement_datum_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_datum_id"], name: "index_problem_entries_on_achievement_datum_id"
  end

  create_table "problems", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer "server_id"
    t.string "problem_id"
    t.string "short_name"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label"
    t.index ["id"], name: "id", unique: true
    t.index ["server_id", "problem_id"], name: "index_problems_on_server_id_and_problem_id", unique: true
    t.index ["server_id", "short_name"], name: "index_problems_on_server_id_and_short_name", unique: true
    t.index ["server_id"], name: "index_problems_on_server_id"
  end

  create_table "servers", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.string "url"
    t.string "api_type"
    t.string "api_endpoint"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "started_at"
    t.integer "contest_id"
    t.string "api_username"
    t.string "api_password"
    t.integer "last_judging"
    t.index ["id"], name: "id", unique: true
  end

  create_table "submissions", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer "problem_id"
    t.integer "account_id"
    t.integer "submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score"
    t.integer "status", default: 0
    t.string "language"
    t.datetime "judged_at"
    t.index ["account_id"], name: "index_submissions_on_account_id"
    t.index ["id"], name: "id", unique: true
    t.index ["problem_id", "submission_id"], name: "index_submissions_on_problem_id_and_submission_id", unique: true
    t.index ["problem_id"], name: "index_submissions_on_problem_id"
  end

  create_table "users", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "admin", default: false
    t.boolean "ldap_user", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["id"], name: "id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "webhooks", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name"
    t.string "url"
    t.string "hook_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "id", unique: true
  end

end
