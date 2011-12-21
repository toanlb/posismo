class AddColumnToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :gross_price, :integer, :after => "promotion_id"
    add_column :rewards, :net_price, :integer, :after => "gross_price"
    add_column :rewards, :gross_rate, :decimal,:precision => 10, :scale => 3,:default => 0.0, :after => "net_price"
    add_column :rewards, :net_rate, :decimal,:precision => 10, :scale => 3,:default => 0.0, :after => "gross_rate"
    remove_column :rewards, :price
  end

  def self.down
    remove_column :rewards, :gross_price
    remove_column :rewards, :net_price
    remove_column :rewards, :gross_rate
    remove_column :rewards, :net_rate
    add_column :rewards, :price, :integer, :after => "promotion_id"
  end
end
