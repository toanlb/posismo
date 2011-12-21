class CreateParameterValues < ActiveRecord::Migration
  def self.up
    create_table :parameter_values do |t|
      t.references :promotion
      t.references :parameter_key
      t.string :value
      
      t.timestamps
    end
  end

  def self.down
    drop_table :parameter_values
  end
end
