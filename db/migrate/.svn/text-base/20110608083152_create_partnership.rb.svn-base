class CreatePartnership < ActiveRecord::Migration
  def self.up
    create_table :partnerships do |t|
      t.references :promotion
      t.references :asp
      
      t.timestamps
    end
  end

  def self.down
    drop_table :partnerships
  end
end
