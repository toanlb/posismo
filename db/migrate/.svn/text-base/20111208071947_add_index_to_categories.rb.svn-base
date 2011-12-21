class AddIndexToCategories < ActiveRecord::Migration
  def self.up
    add_index :categories, :category_name
  end

  def self.down
    remove_index :categories, :column => [:category_name]
  end
end
