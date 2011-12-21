class AddColumnToOrdersToAddToCreatedOn < ActiveRecord::Migration
  def self.up
    add_column :orders, :add, :string, :after => "price"
    add_column :orders, :updated_on, :date, :after => "add"
    add_index  :orders, :updated_on
  end

  def self.down
    remove_column :orders, :add
    remove_column :orders, :updated_on
    remove_index  :orders, :updated_on
  end
end
