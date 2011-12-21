class AddColumnToDailies < ActiveRecord::Migration
  def self.up
    add_column :dailies, :asp_id, :integer, :after => "promotion_id"
  end

  def self.down
    remove_column :dailies, :asp_id
  end
end
