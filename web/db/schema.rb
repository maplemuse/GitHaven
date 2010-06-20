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

ActiveRecord::Schema.define(:version => 20100405021755) do

  create_table "links", :force => true do |t|
    t.integer  "repository_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "repository_id",                   :null => false
    t.integer  "user_id",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mode",          :default => "rw", :null => false
  end

  create_table "repositories", :force => true do |t|
    t.integer  "user_id",              :null => false
    t.string   "name",                 :null => false
    t.string   "description"
    t.string   "defaultbranch"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.integer  "tag_id"
    t.integer  "forked_repository_id"
  end

  create_table "sshkeys", :force => true do |t|
    t.string   "name"
    t.text     "key",        :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.integer  "repository_id", :null => false
    t.string   "tag",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "email"
    t.string   "url"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
