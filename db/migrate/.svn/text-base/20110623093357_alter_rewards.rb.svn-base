class AlterRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :promotion_id, :integer, :after => "id"
    remove_column :rewards, :reward_point_id
  end

  def self.down
    remove_column :rewards, :promotion_id
    add_column :rewards, :reward_point_id, :integer, :after => "id"
  end
end
