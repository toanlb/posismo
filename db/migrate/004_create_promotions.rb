class CreatePromotions < ActiveRecord::Migration
  def self.up
    create_table :promotions do |t|
			t.references :client
			t.references :parent
			
			t.boolean :active, :default => false
			
			t.datetime :starts_at
			t.datetime :ends_at
			
			t.string :name, :default => "", :null => false
			t.string :url
			t.text :description
			
			t.boolean :deleted, :default => false
			
      t.timestamps
    end
  end

  def self.down
    drop_table :promotions
  end
end
