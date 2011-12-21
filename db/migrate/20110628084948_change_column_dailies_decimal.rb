class ChangeColumnDailiesDecimal < ActiveRecord::Migration
  def self.up
    change_column :dailies, :click_rate, :decimal,:precision => 10, :scale => 3,:default => 0.0
    change_column :dailies, :conversion_rate, :decimal,:precision => 10, :scale => 3,:default => 0.0
  end

  def self.down
    change_column :dailies, :click_rate, :decimal
    change_column :dailies, :conversion_rate, :decimal
  end
end
