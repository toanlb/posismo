class AddUserAgentToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :user_agent, :text, :after => "referer"
  end

  def self.down
    remove_column :orders, :user_agent
  end
end
