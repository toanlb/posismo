class DeleteAddFromCookieConservations < ActiveRecord::Migration
  def self.up
    remove_column :cookie_conservations, :add
  end

  def self.down
    add_column :cookie_conservations, :add, :string, :after => "set_cookie_value"
  end
end
