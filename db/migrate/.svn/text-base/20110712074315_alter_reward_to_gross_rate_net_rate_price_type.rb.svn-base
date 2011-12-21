class AlterRewardToGrossRateNetRatePriceType < ActiveRecord::Migration
  def self.up
    change_column :rewards, :price_type, :integer, :default => 0
    change_column :rewards, :gross_rate, :decimal,:precision => 10, :scale => 2,:default => 0.0
    change_column :rewards, :net_rate, :decimal,:precision => 10, :scale => 2,:default => 0.0
  end

  def self.down
    change_column :rewards, :price_type, :integer, :default => nil
    change_column :rewards, :gross_rate, :decimal,:precision => 10, :scale => 3,:default => 0.0
    change_column :rewards, :net_rate, :decimal,:precision => 10, :scale => 3,:default => 0.0
  end
end
