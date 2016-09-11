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

ActiveRecord::Schema.define(version: 20160911011456) do

  create_table "days", force: :cascade do |t|
    t.date     "day"
    t.string   "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entry_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "is_default",          default: false
    t.string   "value_type",          default: "manual", null: false
    t.integer  "diff_entry_type1_id"
    t.integer  "diff_entry_type2_id"
  end

  create_table "time_entries", force: :cascade do |t|
    t.integer  "day_id"
    t.integer  "entry_type_id"
    t.float    "second"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
