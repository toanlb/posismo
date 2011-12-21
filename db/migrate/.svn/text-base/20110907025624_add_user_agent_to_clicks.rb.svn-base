class AddUserAgentToClicks < ActiveRecord::Migration
  def self.up
    add_column :clicks, :user_agent, :text, :after => "referer"
  end

  def self.down
    remove_column :clicks, :user_agent
  end
end
