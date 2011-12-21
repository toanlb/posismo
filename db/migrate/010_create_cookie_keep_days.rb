class CreateCookieKeepDays < ActiveRecord::Migration
  def self.up
    create_table :cookie_keep_days do |t|
      t.integer :keep_day, :default => 90
  
      t.timestamps
      
    end
  end

  def self.down
  end
end
