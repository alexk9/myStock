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

ActiveRecord::Schema.define(version: 20130829045648) do

  create_table "highest_anal_masters", primary_key: "stock_code", force: true do |t|
    t.integer  "highest_cnt"
    t.integer  "highest_pair_cnt"
    t.integer  "up_cnt"
    t.integer  "up_pair_cnt"
    t.integer  "down_cnt"
    t.integer  "down_pair_cnt"
    t.integer  "lowest_cnt"
    t.integer  "lowest_pair_cnt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "highest_anal_masters", ["stock_code"], name: "sqlite_autoindex_highest_anal_masters_1", unique: true

  create_table "highest_anals", primary_key: "stock_code", force: true do |t|
    t.integer  "stock_code_seq",            null: false
    t.string   "first_date",     limit: 10
    t.string   "second_date",    limit: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "highest_anals", ["stock_code", "stock_code_seq"], name: "sqlite_autoindex_highest_anals_1", unique: true

  create_table "prices", primary_key: "std_ymd", force: true do |t|
    t.string   "stock_code",  limit: 6
    t.integer  "end_price"
    t.integer  "comp_last"
    t.string   "comp_dir",    limit: 10
    t.integer  "start_price"
    t.integer  "high_price"
    t.integer  "low_price"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["std_ymd", "stock_code"], name: "sqlite_autoindex_prices_1", unique: true

  create_table "stocks", primary_key: "stock_code", force: true do |t|
    t.string   "company_name"
    t.string   "biz_category"
    t.string   "market"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stocks", ["stock_code"], name: "sqlite_autoindex_stocks_1", unique: true

  create_table "templates", force: true do |t|
    t.string   "temp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "working_dates", primary_key: "std_ymd", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "working_dates", ["std_ymd"], name: "sqlite_autoindex_working_dates_1", unique: true

end
