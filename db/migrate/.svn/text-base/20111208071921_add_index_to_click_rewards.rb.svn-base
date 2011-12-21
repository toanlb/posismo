class AddIndexToClickRewards < ActiveRecord::Migration
  def self.up
    add_index :click_rewards, :promotion_id
  end

  def self.down
    remove_index :click_rewards, :column => [:promotion_id]
  end
end
