class AddAdjustedToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :adjusted, :boolean, :after => "net_rate"
  end

  def self.down
    remove_column :orders, :adjusted
  end
end
