class CreateAsps < ActiveRecord::Migration
  def self.up
    create_table :asps do |t|
      t.string :name
      t.text :tag
      
      t.timestamps
    end
  end

  def self.down
    drop_table :asps
  end
end
