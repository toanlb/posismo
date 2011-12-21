class AddBidToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :banner_id, :integer, :after => "publish_id"
  end

  def self.down
    remove_column :orders, :banner_id
  end
end
