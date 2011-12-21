class Categories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :parent_id,:default => nil
			t.string  :category_name
			t.boolean :deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
