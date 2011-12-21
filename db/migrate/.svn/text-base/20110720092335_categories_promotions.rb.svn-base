class CategoriesPromotions < ActiveRecord::Migration
  def self.up
    create_table :categories_promotions do |t|
      t.references :promotion
			t.references :category

      t.timestamps
    end
  end

  def self.down
    drop_table :categories_promotions
  end
end
