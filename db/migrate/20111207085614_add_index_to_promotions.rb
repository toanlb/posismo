class AddIndexToPromotions < ActiveRecord::Migration
  def self.up
    add_index :promotions, :client_id
  end

  def self.down
    remove_index :promotions, :column => [:client_id]
  end
end
