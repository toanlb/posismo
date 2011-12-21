class AdddailyToclickValidCount < ActiveRecord::Migration
  def self.up
      add_column :dailies, :click_valid_count, :integer, :after => "click_count"
  end

  def self.down
      remove_column :dailies, :click_valid_count
  end
end
