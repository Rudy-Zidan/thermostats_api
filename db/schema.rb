# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_22_234110) do

  create_table "readings", force: :cascade do |t|
    t.integer "thermostat_id"
    t.integer "tracking_number"
    t.float "temperature"
    t.float "humidity"
    t.float "battery_charge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["thermostat_id"], name: "index_readings_on_thermostat_id"
    t.index ["tracking_number"], name: "index_readings_on_tracking_number"
  end

  create_table "thermostats", force: :cascade do |t|
    t.text "household_token"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "readings", "thermostats"
end
