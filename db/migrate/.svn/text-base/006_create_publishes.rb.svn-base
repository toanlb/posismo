class CreatePublishes < ActiveRecord::Migration
  def self.up
    create_table :publishes do |t|
      t.references :promotion
      t.references :site

      t.integer :approval_status, :default => 0, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :publishes
  end
end
