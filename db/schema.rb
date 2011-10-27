# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111027042423) do

  create_table "tags", :force => true do |t|
    t.string   "tag_value"
    t.string   "tag_normalized"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags_urls", :id => false, :force => true do |t|
    t.integer "url_id"
    t.integer "tag_id"
  end

  create_table "urls", :force => true do |t|
    t.text     "original_url"
    t.string   "hashed_url"
    t.string   "hashed_edit_url"
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
  end

end
