class DeleteParameters < ActiveRecord::Migration
  def self.up
    drop_table :parameters
  end

  def self.down
    create_table :parameters do |t|
      t.references :asp
      t.references :promotion
      
      t.string :name
      t.string :value
      
      t.timestamps
    end
  end
end
