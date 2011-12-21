class AddColumnToAsps < ActiveRecord::Migration
  def self.up
    add_column :asps, :client_id, :integer, :after => "id"
  end

  def self.down
    remove_column :asps, :client_id
  end
end
