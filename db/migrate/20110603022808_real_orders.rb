class RealOrders < ActiveRecord::Migration
  def self.up
      create_table :real_orders do |t|
          t.references :reward_point
          t.string :metadata
          t.date :customer_register_on
          
          t.timestamps
      end
  end

  def self.down
      drop_table :real_orders
  end
end
