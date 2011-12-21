class AddBannerToImpressions < ActiveRecord::Migration
  def self.up
    add_column :impressions, :banner_id, :integer, :after => "publish_id"
  end

  def self.down
    remove_column :impressions, :banner_id
  end
end
