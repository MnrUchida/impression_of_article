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

ActiveRecord::Schema[7.0].define(version: 2023_05_02_054856) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "otp_secret"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.string "url", null: false
    t.string "image_url"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uploaded_image_url"
  end

  create_table "creator_articles", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.bigint "article_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_creator_articles_on_article_id"
    t.index ["creator_id"], name: "index_creator_articles_on_creator_id"
  end

  create_table "creators", force: :cascade do |t|
    t.string "name", null: false
    t.string "url"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impression_tags", force: :cascade do |t|
    t.bigint "impression_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["impression_id"], name: "index_impression_tags_on_impression_id"
    t.index ["tag_id"], name: "index_impression_tags_on_tag_id"
  end

  create_table "impressions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "article_id", null: false
    t.string "summary", null: false
    t.text "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.index ["article_id"], name: "index_impressions_on_article_id"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "mastodon_data_linkages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "site", null: false
    t.string "token", limit: 512, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_mastodon_data_linkages_on_user_id"
  end

  create_table "music_articles", force: :cascade do |t|
    t.bigint "music_id", null: false
    t.bigint "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_music_articles_on_article_id"
    t.index ["music_id"], name: "index_music_articles_on_music_id"
  end

  create_table "music_creators", force: :cascade do |t|
    t.bigint "music_id", null: false
    t.bigint "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_music_creators_on_creator_id"
    t.index ["music_id"], name: "index_music_creators_on_music_id"
  end

  create_table "musics", force: :cascade do |t|
    t.string "title", null: false
    t.string "url", null: false
    t.string "image_url"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tag_group_tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tag_group_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_group_id"], name: "index_tag_group_tags_on_tag_group_id"
    t.index ["tag_id"], name: "index_tag_group_tags_on_tag_id"
    t.index ["user_id"], name: "index_tag_group_tags_on_user_id"
  end

  create_table "tag_groups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "sort_order", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tag_groups_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "otp_secret"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login"
    t.boolean "show_name", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "creator_articles", "articles"
  add_foreign_key "creator_articles", "creators"
  add_foreign_key "impression_tags", "impressions"
  add_foreign_key "impression_tags", "tags"
  add_foreign_key "impressions", "articles"
  add_foreign_key "impressions", "users"
  add_foreign_key "mastodon_data_linkages", "users"
  add_foreign_key "music_articles", "articles"
  add_foreign_key "music_articles", "musics"
  add_foreign_key "music_creators", "creators"
  add_foreign_key "music_creators", "musics"
  add_foreign_key "tag_group_tags", "tag_groups"
  add_foreign_key "tag_group_tags", "tags"
  add_foreign_key "tag_group_tags", "users"
  add_foreign_key "tag_groups", "users"

  create_view "randomized_impressions", sql_definition: <<-SQL
      SELECT impressions.id,
      impressions.user_id,
      impressions.article_id,
      impressions.summary,
      impressions.detail,
      impressions.created_at,
      impressions.updated_at,
      impressions.status
     FROM impressions
    WHERE (impressions.status = 1)
    ORDER BY (random())
   LIMIT 100;
  SQL
end
