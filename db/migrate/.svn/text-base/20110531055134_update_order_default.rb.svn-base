class UpdateOrderDefault < ActiveRecord::Migration
  def self.up
      change_column_default :orders, :status_flag, 0
  end

  def self.down
      change_column_default :orders, :status_flag, null
  end
end
