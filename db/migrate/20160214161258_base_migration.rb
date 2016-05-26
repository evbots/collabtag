class BaseMigration < ActiveRecord::Migration
  def change
    create_table "delayed_jobs", force: :cascade do |t|
      t.integer  "priority",   default: 0, null: false
      t.integer  "attempts",   default: 0, null: false
      t.text     "handler",                null: false
      t.text     "last_error"
      t.datetime "run_at"
      t.datetime "locked_at"
      t.datetime "failed_at"
      t.string   "locked_by"
      t.string   "queue"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

    create_table "feedbacks", force: :cascade do |t|
      t.integer  "user_id",    null: false
      t.string   "content"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "group_lists", force: :cascade do |t|
      t.integer  "user_id",    null: false
      t.integer  "school_id",  null: false
      t.text     "list"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "groups", force: :cascade do |t|
      t.string   "url"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "tags"
      t.text     "school"
    end

    create_table "images", force: :cascade do |t|
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "profile_picture_file_name"
      t.string   "profile_picture_content_type"
      t.integer  "profile_picture_file_size"
      t.datetime "profile_picture_updated_at"
      t.string   "direct_upload_url"
      t.string   "previous_direct_upload_url"
      t.boolean  "processed",                    default: false, null: false
      t.boolean  "invalid_upload",               default: false, null: false
    end

    add_index "images", ["processed"], name: "index_images_on_processed", using: :btree
    add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree

    create_table "notifications", force: :cascade do |t|
      t.integer  "user_id",    null: false
      t.text     "metadata",   null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "post_id"
    end

    create_table "posts", force: :cascade do |t|
      t.integer  "user_id"
      t.integer  "group_id"
      t.text     "body"
      t.boolean  "anon",       default: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "schools", force: :cascade do |t|
      t.text     "code",         null: false
      t.text     "name",         null: false
      t.text     "display_name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "users", force: :cascade do |t|
      t.string   "email",                  default: "", null: false
      t.string   "encrypted_password",     default: "", null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0,  null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "unconfirmed_email"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "location"
      t.string   "username"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "facebook_uid"
      t.text     "image_url"
    end

    add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
    add_index "users", ["facebook_uid"], name: "index_users_on_facebook_uid", using: :btree
    add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end
end
