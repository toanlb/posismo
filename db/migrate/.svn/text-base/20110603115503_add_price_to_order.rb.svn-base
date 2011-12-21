class AddPriceToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :price, :integer, :default => 0, :after => "status_flag"
  end

  def self.down
    remove_column :orders, :price
  end
end
