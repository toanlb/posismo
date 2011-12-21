class RewardPoints < ActiveRecord::Migration
  def self.up
      create_table :reward_points do |t|
          t.references :promotion
          t.string :name

          t.timestamps
      end
  end

  def self.down
      drop_table :reward_pointss
  end
end
