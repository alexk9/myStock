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

ActiveRecord::Schema.define(version: 20130821010922) do

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

end
