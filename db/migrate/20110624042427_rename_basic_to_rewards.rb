class RenameBasicToRewards < ActiveRecord::Migration
  def self.up
    rename_column(:rewards, :basic, :reward_type)
  end

  def self.down
    rename_column(:rewards, :reward_type, :basic)
  end
end
