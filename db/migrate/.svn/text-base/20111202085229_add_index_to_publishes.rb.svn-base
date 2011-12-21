class AddIndexToPublishes < ActiveRecord::Migration
  def self.up
    add_index :publishes, :promotion_id
    add_index :publishes, :site_id
    add_index :publishes, :asp_id
  end

  def self.down
    remove_index :publishes, :column => [:promotion_id]
    remove_index :publishes, :column => [:site_id]
    remove_index :publishes, :column => [:asp_id]
  end
end
