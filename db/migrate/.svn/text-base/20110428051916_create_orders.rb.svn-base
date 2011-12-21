class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :publish
      
      t.string :remote_address
      t.string :referer
      t.string :metadata 
      t.integer :status_flag 
      t.date :created_on
  
      t.timestamps
      
    end
    
  end

  def self.down
    drop_table :orders
  end
end
