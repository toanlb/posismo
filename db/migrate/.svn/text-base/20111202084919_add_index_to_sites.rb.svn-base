class AddIndexToSites < ActiveRecord::Migration
  def self.up
    add_index :sites, :partner_id
  end

  def self.down
    remove_index :sites, :column => [:partner_id]
  end
end
