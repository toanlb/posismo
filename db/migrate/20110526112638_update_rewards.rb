class UpdateRewards < ActiveRecord::Migration
  def self.up
      change_column_default :rewards, :price, 0
  end

  def self.down
      change_column_default :rewards, :price, null
  end
end
