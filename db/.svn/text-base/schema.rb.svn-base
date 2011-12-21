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

ActiveRecord::Schema.define(:version => 20111208071947) do

  create_table "account_managements", :force => true do |t|
    t.integer  "admin_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", :force => true do |t|
    t.string   "login_id",                            :default => "",    :null => false
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "name",                                                   :null => false
    t.boolean  "super_user",                          :default => false
    t.boolean  "deleted",                             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "asps", :force => true do |t|
    t.integer  "client_id"
    t.string   "name"
    t.text     "tag"
    t.boolean  "always_extract"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banners", :force => true do |t|
    t.integer  "promotion_id"
    t.string   "name"
    t.text     "description"
    t.string   "type"
    t.string   "text"
    t.string   "image"
    t.string   "image_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "category_name"
    t.boolean  "deleted",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["category_name"], :name => "index_categories_on_category_name"

  create_table "categories_promotions", :force => true do |t|
    t.integer  "promotion_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_sites", :force => true do |t|
    t.integer  "site_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "click_rewards", :force => true do |t|
    t.integer  "promotion_id"
    t.integer  "price",        :default => 0
    t.datetime "starts_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "click_rewards", ["promotion_id"], :name => "index_click_rewards_on_promotion_id"

  create_table "clicks", :force => true do |t|
    t.integer  "publish_id"
    t.integer  "banner_id"
    t.string   "remote_address"
    t.string   "referer"
    t.text     "user_agent"
    t.integer  "click_count",       :default => 0
    t.integer  "click_valid_count", :default => 0
    t.string   "add_data"
    t.date     "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clicks", ["created_on"], :name => "index_clicks_on_created_on"
  add_index "clicks", ["publish_id"], :name => "index_clicks_on_publish_id"

  create_table "client_monthlies", :force => true do |t|
    t.integer  "client_id"
    t.string   "login_id"
    t.string   "company_name"
    t.string   "manager_name"
    t.integer  "charge"
    t.integer  "count_partner"
    t.string   "month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_monthlies", ["login_id"], :name => "index_client_monthlies_on_login_id"
  add_index "client_monthlies", ["month"], :name => "index_client_monthlies_on_month"

  create_table "clients", :force => true do |t|
    t.string   "login_id",                             :default => "",    :null => false
    t.string   "email",                                :default => "",    :null => false
    t.string   "encrypted_password",    :limit => 128, :default => "",    :null => false
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "reset_password_token"
    t.boolean  "consigned",                            :default => false
    t.integer  "registration_status",                  :default => 0,     :null => false
    t.string   "site_name"
    t.string   "site_url"
    t.string   "company_name"
    t.string   "company_name_kana"
    t.string   "contractor_department"
    t.string   "contractor_position"
    t.string   "contractor_name"
    t.string   "contractor_name_kana"
    t.string   "manager_department"
    t.string   "manager_position"
    t.string   "manager_name"
    t.string   "manager_name_kana"
    t.string   "postal_code"
    t.string   "address"
    t.string   "tel"
    t.text     "memo"
    t.boolean  "activated",                            :default => false
    t.boolean  "deleted",                              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["login_id"], :name => "index_clients_on_login_id"

  create_table "converts", :force => true do |t|
    t.string   "id_type"
    t.string   "old_id"
    t.string   "new_id"
    t.boolean  "deleted",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "converts", ["id_type", "old_id"], :name => "index_converts_on_id_type_and_old_id", :unique => true

  create_table "cookie_conservations", :force => true do |t|
    t.integer  "click_id"
    t.text     "set_cookie_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cookie_keep_days", :force => true do |t|
    t.integer  "keep_day",   :default => 90
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dailies", :force => true do |t|
    t.integer  "publish_id"
    t.integer  "banner_id"
    t.integer  "partner_id"
    t.integer  "site_id"
    t.integer  "client_id"
    t.integer  "promotion_id"
    t.integer  "asp_id"
    t.integer  "impression_count",                                      :default => 0
    t.integer  "click_count",                                           :default => 0
    t.integer  "click_valid_count",                                     :default => 0
    t.decimal  "click_rate",             :precision => 10, :scale => 3, :default => 0.0
    t.integer  "final_click_reward",                                    :default => 0
    t.decimal  "conversion_rate",        :precision => 10, :scale => 3, :default => 0.0
    t.integer  "plan_order_count",                                      :default => 0
    t.integer  "final_order_count",                                     :default => 0
    t.integer  "cancel_order_count",                                    :default => 0
    t.integer  "plan_order_reward",                                     :default => 0
    t.integer  "plan_order_net_reward",                                 :default => 0
    t.integer  "final_order_reward",                                    :default => 0
    t.integer  "final_order_net_reward",                                :default => 0
    t.integer  "final_all_reward",                                      :default => 0
    t.integer  "final_all_net_reward",                                  :default => 0
    t.date     "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dailies", ["asp_id"], :name => "index_dailies_on_asp_id"
  add_index "dailies", ["click_rate"], :name => "index_dailies_on_click_rate"
  add_index "dailies", ["client_id"], :name => "index_dailies_on_client_id"
  add_index "dailies", ["partner_id"], :name => "index_dailies_on_partner_id"
  add_index "dailies", ["promotion_id"], :name => "index_dailies_on_promotion_id"
  add_index "dailies", ["publish_id"], :name => "index_dailies_on_publish_id"
  add_index "dailies", ["site_id"], :name => "index_dailies_on_site_id"

  create_table "impressions", :force => true do |t|
    t.integer  "publish_id"
    t.integer  "banner_id"
    t.string   "remote_address"
    t.string   "referer"
    t.text     "user_agent"
    t.integer  "impression_count", :default => 0
    t.date     "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["created_on"], :name => "index_impressions_on_created_on"
  add_index "impressions", ["publish_id"], :name => "index_impressions_on_publish_id"

  create_table "notices", :force => true do |t|
    t.text     "title",       :null => false
    t.text     "description", :null => false
    t.integer  "target",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "publish_id"
    t.integer  "banner_id"
    t.integer  "click_id"
    t.string   "remote_address"
    t.string   "referer"
    t.text     "user_agent"
    t.string   "metadata"
    t.integer  "status_flag",                                   :default => 0
    t.integer  "price",                                         :default => 0
    t.integer  "gross_price",                                   :default => 0
    t.integer  "net_price",                                     :default => 0
    t.decimal  "gross_rate",     :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "net_rate",       :precision => 10, :scale => 2, :default => 0.0
    t.boolean  "adjusted"
    t.string   "add_data"
    t.date     "decide_date"
    t.date     "updated_on"
    t.date     "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["banner_id"], :name => "index_orders_on_banner_id"
  add_index "orders", ["click_id"], :name => "index_orders_on_click_id"
  add_index "orders", ["created_on"], :name => "index_orders_on_created_on"
  add_index "orders", ["publish_id"], :name => "index_orders_on_publish_id"
  add_index "orders", ["updated_on"], :name => "index_orders_on_updated_on"

  create_table "partner_monthlies", :force => true do |t|
    t.integer  "partner_id"
    t.string   "login_id"
    t.string   "company_name"
    t.string   "manager_name"
    t.integer  "gross_price"
    t.integer  "net_price"
    t.string   "month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "partner_monthlies", ["login_id"], :name => "index_partner_monthlies_on_login_id"
  add_index "partner_monthlies", ["month"], :name => "index_partner_monthlies_on_month"

  create_table "partners", :force => true do |t|
    t.string   "login_id",                             :default => "",    :null => false
    t.string   "email",                                :default => "",    :null => false
    t.string   "encrypted_password",    :limit => 128, :default => "",    :null => false
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "reset_password_token"
    t.integer  "registration_status",                  :default => 0,     :null => false
    t.string   "media_type"
    t.integer  "contract_type",                        :default => 0,     :null => false
    t.string   "company_name"
    t.string   "company_name_kana"
    t.string   "contractor_department"
    t.string   "contractor_position"
    t.string   "contractor_name"
    t.string   "contractor_name_kana"
    t.string   "manager_department"
    t.string   "manager_position"
    t.string   "manager_name",                         :default => "",    :null => false
    t.string   "manager_name_kana",                    :default => "",    :null => false
    t.string   "postal_code"
    t.string   "address"
    t.string   "tel"
    t.integer  "payment_type",                         :default => 0,     :null => false
    t.string   "bank_name"
    t.string   "bank_code"
    t.string   "branch_name"
    t.string   "branch_code"
    t.string   "account_type"
    t.string   "account_number"
    t.string   "account_name"
    t.string   "jpbank_account_number"
    t.string   "jpbank_account_name"
    t.text     "memo"
    t.boolean  "active",                               :default => false
    t.boolean  "deleted",                              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "partners", ["login_id"], :name => "index_partners_on_login_id"

  create_table "promotions", :force => true do |t|
    t.integer  "client_id"
    t.integer  "parent_id"
    t.boolean  "active",       :default => false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "name",         :default => "",    :null => false
    t.string   "url"
    t.text     "description"
    t.boolean  "opened",       :default => true
    t.integer  "tieup_type",   :default => 0
    t.integer  "listing_type", :default => 0
    t.integer  "enable_add",   :default => 0
    t.boolean  "deleted",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "promotions", ["client_id"], :name => "index_promotions_on_client_id"

  create_table "publishes", :force => true do |t|
    t.integer  "promotion_id"
    t.integer  "site_id"
    t.integer  "asp_id"
    t.integer  "approval_status", :default => 0,     :null => false
    t.boolean  "deleted",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publishes", ["asp_id"], :name => "index_publishes_on_asp_id"
  add_index "publishes", ["promotion_id"], :name => "index_publishes_on_promotion_id"
  add_index "publishes", ["site_id"], :name => "index_publishes_on_site_id"

  create_table "rewards", :force => true do |t|
    t.integer  "promotion_id"
    t.integer  "gross_price"
    t.integer  "net_price"
    t.decimal  "gross_rate",   :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "net_rate",     :precision => 10, :scale => 2, :default => 0.0
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "reward_type",                                 :default => 0
    t.integer  "price_type",                                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rewards", ["promotion_id"], :name => "index_rewards_on_promotion_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sites", :force => true do |t|
    t.integer  "partner_id"
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.string   "keywords",    :default => ""
    t.boolean  "deleted",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["partner_id"], :name => "index_sites_on_partner_id"

end
