class AddClickIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :click_id, :integer, :after => "publish_id"
  end

  def self.down
    remove_column :orders, :click_id
  end
end
