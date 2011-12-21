class AddOrdersToGrossPriceNetPriceGrossRateNetRate < ActiveRecord::Migration
  def self.up
    add_column :orders, :gross_price, :integer, :default => 0, :after => "price"
    add_column :orders, :net_price, :integer, :default => 0, :after => "gross_price"
    add_column :orders, :gross_rate, :decimal,:precision => 10, :scale => 2,:default => 0.0, :after => "net_price"
    add_column :orders, :net_rate, :decimal,:precision => 10, :scale => 2,:default => 0.0, :after => "gross_rate"
  end

  def self.down
    remove_column :orders, :gross_price
    remove_column :orders, :net_price
    remove_column :orders, :gross_rate
    remove_column :orders, :net_rate
  end
end
