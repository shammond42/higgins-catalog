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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121216225002) do

  create_table "artifact_images", :force => true do |t|
    t.integer  "artifact_id", :null => false
    t.string   "path",        :null => false
    t.integer  "sort_order"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "artifact_images", ["artifact_id"], :name => "index_artifact_images_on_artifact_id"

  create_table "artifacts", :force => true do |t|
    t.string   "accession_number"
    t.string   "std_term"
    t.string   "alt_name"
    t.string   "prob_date"
    t.integer  "min_date"
    t.integer  "max_date"
    t.string   "artist"
    t.string   "school_period"
    t.string   "geoloc"
    t.string   "origin"
    t.string   "materials"
    t.text     "measure"
    t.string   "weight"
    t.text     "comments"
    t.text     "bibliography"
    t.text     "published_refs"
    t.text     "label_text"
    t.text     "old_labels"
    t.text     "exhibit_history"
    t.text     "description"
    t.text     "marks"
    t.text     "public_loc"
    t.text     "status"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "artifacts", ["accession_number"], :name => "index_artifacts_on_accession_number", :unique => true
  add_index "artifacts", ["max_date"], :name => "index_artifacts_on_max_date"
  add_index "artifacts", ["min_date"], :name => "index_artifacts_on_min_date"

  create_table "category_synonyms", :force => true do |t|
    t.string "category", :null => false
    t.string "synonym",  :null => false
    t.text   "note"
  end

  add_index "category_synonyms", ["category"], :name => "index_category_xrefs_on_category"
  add_index "category_synonyms", ["synonym"], :name => "index_category_xrefs_on_xref"

  create_table "geoloc_synonyms", :force => true do |t|
    t.string "geoloc",  :null => false
    t.string "synonym", :null => false
  end

  add_index "geoloc_synonyms", ["geoloc"], :name => "index_geoloc_synonyms_on_geoloc"

  create_table "questions", :force => true do |t|
    t.string   "email"
    t.string   "nickname"
    t.text     "question"
    t.text     "answer"
    t.integer  "artifact_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "questions", ["artifact_id"], :name => "index_questions_on_artifact_id"

  create_table "search_logs", :force => true do |t|
    t.string   "terms"
    t.string   "type"
    t.integer  "linked_search"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                  :default => "", :null => false
    t.string   "title"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
