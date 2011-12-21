class AddBidToDailies < ActiveRecord::Migration
  def self.up
    add_column :dailies, :banner_id, :integer, :after => "publish_id"
  end

  def self.down
    remove_column :dailies, :banner_id
  end
end
