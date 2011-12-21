class AddIndexToDailies < ActiveRecord::Migration
  def self.up
    add_index :dailies, :asp_id
  end

  def self.down
    remove_index :dailies, :asp_id
  end
end
