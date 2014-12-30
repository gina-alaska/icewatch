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

ActiveRecord::Schema.define(version: 20141229191704) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clouds", force: true do |t|
    t.integer  "meteorology_id"
    t.integer  "cloud_lookup_id"
    t.integer  "cover"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cloud_type"
  end

  create_table "comments", force: true do |t|
    t.string   "text"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "observation_id"
  end

  create_table "cruises", force: true do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "objective"
    t.boolean  "approved"
    t.integer  "ship_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "chief_scientist"
    t.string   "captain"
    t.string   "primary_observer"
    t.string   "name"
    t.string   "ship"
    t.boolean  "archived",         default: false
  end

  create_table "faunas", force: true do |t|
    t.string   "name"
    t.integer  "count"
    t.integer  "observation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ice_observations", force: true do |t|
    t.integer  "observation_id"
    t.integer  "floe_size_lookup_id"
    t.integer  "snow_lookup_id"
    t.integer  "ice_lookup_id"
    t.integer  "algae_lookup_id"
    t.integer  "algae_density_lookup_id"
    t.integer  "sediment_lookup_id"
    t.integer  "partial_concentration"
    t.integer  "thickness"
    t.integer  "snow_thickness"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "algae_location_lookup_id"
    t.string   "obs_type"
  end

  create_table "ices", force: true do |t|
    t.integer  "observation_id"
    t.integer  "total_concentration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "open_water_lookup_id"
    t.integer  "thick_ice_lookup_id"
    t.integer  "thin_ice_lookup_id"
  end

  create_table "lookups", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "type"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "height"
    t.string   "group"
  end

  create_table "melt_ponds", force: true do |t|
    t.integer  "ice_observation_id"
    t.integer  "max_depth_lookup_id"
    t.integer  "surface_lookup_id"
    t.integer  "pattern_lookup_id"
    t.integer  "bottom_type_lookup_id"
    t.integer  "surface_coverage"
    t.integer  "freeboard"
    t.boolean  "dried_ice"
    t.boolean  "rotten_ice"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meteorologies", force: true do |t|
    t.integer  "observation_id"
    t.integer  "weather_lookup_id"
    t.integer  "visibility_lookup_id"
    t.integer  "total_cloud_cover"
    t.integer  "wind_speed"
    t.string   "wind_direction"
    t.float    "air_temperature"
    t.float    "water_temperature"
    t.integer  "relative_humidity"
    t.integer  "air_pressure"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.string   "text"
    t.integer  "observation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "observations", force: true do |t|
    t.integer  "cruise_id"
    t.datetime "observed_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "uuid"
    t.boolean  "approved",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "people", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "person_observations", force: true do |t|
    t.boolean  "primary"
    t.integer  "observation_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ships", force: true do |t|
    t.integer  "heading"
    t.integer  "power"
    t.integer  "speed"
    t.integer  "ship_activity_lookup_id"
    t.integer  "observation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topographies", force: true do |t|
    t.integer  "ice_observation_id"
    t.boolean  "old"
    t.boolean  "snow_covered"
    t.integer  "concentration"
    t.float    "ridge_height"
    t.integer  "topography_lookup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "consolidated"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",       default: "guest"
  end

end
