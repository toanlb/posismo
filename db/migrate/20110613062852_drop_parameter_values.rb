class DropParameterValues < ActiveRecord::Migration
  def self.up
    drop_table :parameter_values
  end

  def self.down
  end
end
