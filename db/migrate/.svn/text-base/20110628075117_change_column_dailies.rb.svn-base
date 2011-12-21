class ChangeColumnDailies < ActiveRecord::Migration
  def self.up
    change_column :dailies, :click_rate, :decimal
    change_column :dailies, :conversion_rate, :decimal
  end

  def self.down
    change_column :dailies, :click_rate, :integer
    change_column :dailies, :conversion_rate, :integer
  end
end
