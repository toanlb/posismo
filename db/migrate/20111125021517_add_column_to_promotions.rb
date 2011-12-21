class AddColumnToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :enable_add, :integer, :default => false, :after => "opened"
    add_column :promotions, :listing_type, :integer, :default => false, :after => "opened"
    add_column :promotions, :tieup_type, :integer, :default => false, :after => "opened"
  end

  def self.down
    remove_column :promotions, :tieup_type
    remove_column :promotions, :listing_type
    remove_column :promotions, :enable_add
  end
end
