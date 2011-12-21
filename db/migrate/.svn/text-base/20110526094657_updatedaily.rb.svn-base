class Updatedaily < ActiveRecord::Migration
  def self.up
      add_column :dailies, :plan_order_count, :integer, :after => "conversion_rate"
      remove_column :dailies, :order_count
  end

  def self.down
      remove_column :dailies, :plan_order_count
  end
end
