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

ActiveRecord::Schema[8.0].define(version: 2025_10_02_083916) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "postgis"

  create_table "list_places", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.bigint "place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_list_places_on_list_id"
    t.index ["place_id"], name: "index_list_places_on_place_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.geography "geom", limit: {srid: 4326, type: "st_point", geographic: true}, null: false
    t.string "name", null: false
    t.string "description"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.string "phone"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_places_on_creator_id"
    t.index ["name"], name: "index_places_on_name", unique: true
  end

  create_table "points", force: :cascade do |t|
    t.string "name"
    t.geography "geom", limit: {srid: 4326, type: "st_point", geographic: true}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geom"], name: "index_points_on_geom", using: :gist
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "list_places", "lists"
  add_foreign_key "list_places", "places"
  add_foreign_key "lists", "users"
  add_foreign_key "places", "users", column: "creator_id"
end
