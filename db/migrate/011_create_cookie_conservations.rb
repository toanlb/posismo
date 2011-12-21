class CreateCookieConservations < ActiveRecord::Migration
  def self.up
    create_table :cookie_conservations do |t|
      t.references :click
      
      t.text :set_cookie_value
  
      t.timestamps
      
    end
  end

  def self.down
  end
end
