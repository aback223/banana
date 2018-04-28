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

ActiveRecord::Schema.define(version: 20180428204604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aria_reports", force: :cascade do |t|
    t.string  "floorplan"
    t.integer "vacant"
    t.decimal "vacant_pct"
    t.integer "avail"
    t.decimal "avail_pct"
    t.integer "exposure"
    t.decimal "exp_pct"
    t.integer "min"
    t.integer "max"
    t.integer "avg"
    t.integer "date_id"
  end

  create_table "aria_static_data", force: :cascade do |t|
    t.string  "floorplan"
    t.integer "total"
    t.integer "source_id"
  end

  create_table "daily_data", force: :cascade do |t|
    t.string "date"
    t.string "occupancy"
    t.string "leased"
  end

  create_table "dates", force: :cascade do |t|
    t.string "date"
    t.string "source_id"
  end

  create_table "days", force: :cascade do |t|
    t.string  "date"
    t.string  "rent"
    t.integer "listing_id"
    t.index ["listing_id"], name: "index_days_on_listing_id", using: :btree
  end

  create_table "listings", force: :cascade do |t|
    t.string  "unit_number"
    t.string  "unit_type"
    t.string  "sq_feet"
    t.string  "availability"
    t.string  "source"
    t.integer "location_id"
    t.string  "floorplan"
    t.string  "image"
  end

  create_table "locations", force: :cascade do |t|
    t.string "city_state"
  end

  create_table "sources", force: :cascade do |t|
    t.string  "name"
    t.integer "location_id"
  end

end
