class CreateParameters2 < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.references :asp
      t.references :promotion
      
      t.string :name
      t.integer :metadata_flg, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :parameters
  end
end
