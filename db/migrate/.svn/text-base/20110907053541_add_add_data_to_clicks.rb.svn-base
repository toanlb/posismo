class AddAddDataToClicks < ActiveRecord::Migration
  def self.up
    add_column :clicks, :add_data, :string, :after => "tag"
  end

  def self.down
    remove_column :clicks, :add_data
  end
end
