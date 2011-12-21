class AlterAddToAddDataFromOrders < ActiveRecord::Migration
  def self.up
    rename_column :orders, :add, :add_data
  end

  def self.down
    rename_column :orders, :add_data, :add
  end
end
