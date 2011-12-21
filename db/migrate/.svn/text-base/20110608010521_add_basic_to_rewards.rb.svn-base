class AddBasicToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :basic, :integer, :default => 0, :after => "ends_at"
  end

  def self.down
    remove_column :rewards, :basic
  end
end
