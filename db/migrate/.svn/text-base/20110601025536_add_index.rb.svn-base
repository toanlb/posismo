class AddIndex < ActiveRecord::Migration
  def self.up
    add_index :orders, :click_id
    add_index :orders, :created_on
    add_index :impressions, :created_on
    add_index :impressions, :publish_id
    add_index :clicks, :publish_id
    add_index :clicks, :created_on
    add_index :dailies, :publish_id
    add_index :dailies, :partner_id
    add_index :dailies, :site_id
    add_index :dailies, :client_id
    add_index :dailies, :promotion_id
    add_index :dailies, :click_rate
  end

  def self.down
    remove_index :orders, :click_id
    remove_index :orders, :created_on
    remove_index :impressions, :created_on
    remove_index :impressions, :publish_id
    remove_index :clicks, :publish_id
    remove_index :clicks, :created_on
    remove_index :dailies, :publish_id
    remove_index :dailies, :partner_id
    remove_index :dailies, :site_id
    remove_index :dailies, :client_id
    remove_index :dailies, :promotion_id
    remove_index :dailies, :click_rate
  end
end
