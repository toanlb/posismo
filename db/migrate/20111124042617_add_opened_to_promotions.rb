class AddOpenedToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :opened, :boolean, :default => true, :after => "description"
  end

  def self.down
    remove_column :promotions, :opened
  end
end
