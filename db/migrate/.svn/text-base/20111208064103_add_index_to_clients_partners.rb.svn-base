class AddIndexToClientsPartners < ActiveRecord::Migration
  def self.up
    add_index :clients, :login_id
    add_index :partners, :login_id
    add_index :rewards, :promotion_id
  end

  def self.down
    remove_index :clients, :column => [:login_id]
    remove_index :partners, :column => [:login_id]
    remove_index :rewards, :column => [:promotion_id]
  end
end
