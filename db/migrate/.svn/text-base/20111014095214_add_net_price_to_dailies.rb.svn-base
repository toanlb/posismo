class AddNetPriceToDailies < ActiveRecord::Migration
  def self.up
    add_column :dailies, :plan_order_net_reward, :integer, :default => 0, :after => "plan_order_reward"
    add_column :dailies, :final_order_net_reward, :integer, :default => 0, :after => "final_order_reward"
    add_column :dailies, :final_all_net_reward, :integer, :default => 0, :after => "final_all_reward"
  end

  def self.down
    remove_column :dailies, :plan_order_net_reward
    remove_column :dailies, :final_order_net_reward
    remove_column :dailies, :final_all_net_reward
  end
end