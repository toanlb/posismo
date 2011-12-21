class DeleteTagFromClicks < ActiveRecord::Migration
  def self.up
    remove_column :clicks, :tag
  end

  def self.down
    add_column :clicks, :add, :text, :after => "click_valid_count"
  end
end
