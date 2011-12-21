class ChangeRewards < ActiveRecord::Migration
  def self.up
    change_table :rewards do |t|
      t.remove :promotion_id
    end
    add_column :rewards, :reward_point_id, :integer, :after => "id"
  end

  def self.down
    change_table :rewards do |t|
      t.remove :reward_point_id
    end
    add_column :rewards, :promotion_id, :integer, :after => "id"
  end
end
