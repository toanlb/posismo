class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.references :asp
      t.references :promotion
      
      t.string :name
      t.string :value
      
      t.timestamps
    end
  end

  def self.down
    drop_table :parameters
  end
end
