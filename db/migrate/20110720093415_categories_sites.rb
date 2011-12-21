class CategoriesSites < ActiveRecord::Migration
  def self.up
    create_table :categories_sites do |t|
      t.references :site
			t.references :category

      t.timestamps
    end
  end

  def self.down
    drop_table :categories_sites
  end
end
