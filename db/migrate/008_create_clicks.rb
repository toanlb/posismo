class CreateClicks < ActiveRecord::Migration
  def self.up
    create_table :clicks do |t|
      t.references :publish
      
      t.string :remote_address
      t.string :referer
      t.integer :click_count, :default => 0 
      t.integer :click_valid_count, :default => 0
      t.text :tag
      t.date :created_on
  
      t.timestamps
      
    end
  end

  def self.down
  end
end
