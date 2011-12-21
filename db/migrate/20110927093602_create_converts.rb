class CreateConverts < ActiveRecord::Migration
  def self.up
    create_table :converts do |t|
      t.string :id_type
      t.string :old_id
      t.string :new_id
      t.boolean :deleted, :default => false
      
      t.timestamps
    end

    add_index :converts, [:id_type, :old_id], :unique => true
  end

  def self.down
    drop_table :converts
  end
end
