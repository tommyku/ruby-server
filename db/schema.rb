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

ActiveRecord::Schema.define(version: 20161128001641) do

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "content",                              limit: 65535
    t.text     "local_encrypted_content",              limit: 65535
    t.string   "local_eek"
    t.string   "local_encryption_scheme"
    t.text     "encrypted_local_encrypted_content",    limit: 65535
    t.string   "encrypted_local_encrypted_content_iv"
    t.text     "encrypted_content",                    limit: 65535
    t.string   "encrypted_content_iv"
    t.string   "encrypted_name"
    t.string   "encrypted_name_iv"
    t.boolean  "shared_via_group",                                   default: false
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
  end

  create_table "presentations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "root_path"
    t.string   "parent_path"
    t.string   "relative_path"
    t.string   "host"
    t.boolean  "enabled",          default: true
    t.integer  "presentable_id"
    t.string   "presentable_type"
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "provider",                               default: "email", null: false
    t.string   "uid",                                    default: "",      null: false
    t.string   "encrypted_password",                     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.text     "tokens",                   limit: 65535
    t.boolean  "local_encryption_enabled"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

end
