class UpdateDailyColumnDefault < ActiveRecord::Migration
  def self.up
      change_column_default :dailies, :impression_count, 0
      change_column_default :dailies, :click_count, 0
      change_column_default :dailies, :click_valid_count, 0
      change_column_default :dailies, :click_rate, 0
      change_column_default :dailies, :final_click_reward, 0
      change_column_default :dailies, :conversion_rate, 0
      change_column_default :dailies, :plan_order_count, 0
      change_column_default :dailies, :final_order_count, 0
      change_column_default :dailies, :cancel_order_count, 0
      change_column_default :dailies, :plan_order_reward, 0
      change_column_default :dailies, :final_order_reward, 0
      change_column_default :dailies, :final_all_reward, 0
  end

  def self.down
      change_column_default :dailies, :impression_count, null
      change_column_default :dailies, :click_count, null
      change_column_default :dailies, :click_valid_count, null
      change_column_default :dailies, :click_rate, null
      change_column_default :dailies, :final_click_reward, null
      change_column_default :dailies, :conversion_rate, null
      change_column_default :dailies, :plan_order_count, null
      change_column_default :dailies, :final_order_count, null
      change_column_default :dailies, :cancel_order_count, null
      change_column_default :dailies, :plan_order_reward, null
      change_column_default :dailies, :final_order_reward, null
      change_column_default :dailies, :final_all_reward, null
  end
end
