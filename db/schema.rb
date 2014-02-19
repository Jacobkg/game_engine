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

ActiveRecord::Schema.define(version: 20140219031810) do

  create_table "boards", force: true do |t|
    t.integer  "x_score"
    t.integer  "y_score"
    t.string   "x_position"
    t.string   "y_position"
    t.string   "stars"
    t.string   "player_to_move"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: true do |t|
    t.integer  "board_id"
    t.integer  "player1_id"
    t.integer  "player2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "wins",       default: 0
    t.integer  "losses",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end