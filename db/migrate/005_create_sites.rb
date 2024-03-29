class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.references :partner

			t.string :name
			t.string :url
			t.text :description
			t.string :keywords, :default => ""

      t.boolean :deleted, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
