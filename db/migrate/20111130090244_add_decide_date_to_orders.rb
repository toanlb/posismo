class AddDecideDateToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :decide_date, :date, :after => "add_data"
  end

  def self.down
    remove_column :orders, :decide_date
  end
end
