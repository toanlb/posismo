class AddIndexToOrders < ActiveRecord::Migration
  def self.up
    add_index :orders, :publish_id
    add_index :orders, :banner_id
  end

  def self.down
    remove_index :orders, :column => [:publish_id,:banner_id]
    remove_index :orders, :column => [:banner_id]
  end
end
