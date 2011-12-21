class RemoveEndsAtFromClickRewards < ActiveRecord::Migration
  def self.up
    remove_column :click_rewards, :ends_at
  end

  def self.down
    add_column :click_rewards, :ends_at, :datetime
  end
end
