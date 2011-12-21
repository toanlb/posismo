class DropRealOrdersRewardRointsParameters < ActiveRecord::Migration
  def self.up
    drop_table :real_orders
    drop_table :reward_points
    drop_table :parameters
  end

  def self.down
    create_table "real_orders", :force => true do |t|
      t.integer  "reward_point_id"
      t.string   "metadata"
      t.date     "customer_register_on"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "reward_points", :force => true do |t|
      t.integer  "promotion_id"
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "parameters", :force => true do |t|
      t.integer  "asp_id"
      t.string   "name"
      t.integer  "metadata_flg", :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
