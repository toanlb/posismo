class AddBannerToClicks < ActiveRecord::Migration
  def self.up
    add_column :clicks, :banner_id, :integer, :after => "publish_id"
  end

  def self.down
    remove_column :clicks, :banner_id
  end
end
