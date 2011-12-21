class AddDeletedToPublishes < ActiveRecord::Migration
  def self.up
    add_column :publishes, :deleted, :boolean, :default => 0, :after => "approval_status"
  end

  def self.down
    remove_column :publishes, :deleted
  end
end
