class CreateNotices < ActiveRecord::Migration
  def self.up
    create_table :notices do |t|
      t.text :title, :null => false
      t.text :description, :null => false
      t.integer :target, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :notices
  end
end
