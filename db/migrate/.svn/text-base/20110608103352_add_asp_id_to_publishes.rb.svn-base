class AddAspIdToPublishes < ActiveRecord::Migration
  def self.up
    add_column :publishes, :asp_id, :integer, :after => "site_id"
  end

  def self.down
    remove_column :publishes, :asp_id
  end
end
