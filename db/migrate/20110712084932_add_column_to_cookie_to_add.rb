class AddColumnToCookieToAdd < ActiveRecord::Migration
  def self.up
    add_column :cookie_conservations, :add, :string, :after => "set_cookie_value"
  end

  def self.down
    remove_column :cookie_conservations, :add
  end
end
