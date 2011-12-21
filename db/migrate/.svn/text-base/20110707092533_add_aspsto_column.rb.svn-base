class AddAspstoColumn < ActiveRecord::Migration
  def self.up
    add_column :asps, :always_extract, :boolean, :after => "tag"
  end

  def self.down
    remove_column :asps, :always_extract
  end
end
