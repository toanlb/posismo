class AddPriceTypeToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :price_type, :integer, :after => "reward_type"
  end

  def self.down
    remove_column :rewards, :price_type
  end
end
