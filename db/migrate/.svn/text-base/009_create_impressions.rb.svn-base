class CreateImpressions < ActiveRecord::Migration
  def self.up
    create_table :impressions do |t|
      t.references :publish
      
      t.string :remote_address
      t.string :referer
      t.text :user_agent
      t.integer :impression_count , :default => 0
      t.date :created_on
  
      t.timestamps
      
    end
  end

  def self.down
  end
end
