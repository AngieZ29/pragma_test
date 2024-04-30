# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_04_29_235904) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_csvs", force: :cascade do |t|
    t.date "timestamp"
    t.integer "price"
    t.integer "user_id"
    t.bigint "log_file_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["log_file_id"], name: "index_data_csvs_on_log_file_id"
  end

  create_table "file_statistics", force: :cascade do |t|
    t.integer "total_rows"
    t.float "avg_price"
    t.integer "min_price"
    t.integer "max_price"
    t.bigint "log_file_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sum_price"
    t.integer "nil_price"
    t.index ["log_file_id"], name: "index_file_statistics_on_log_file_id"
  end

  create_table "log_files", force: :cascade do |t|
    t.string "name_csv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "data_csvs", "log_files"
  add_foreign_key "file_statistics", "log_files"
end
