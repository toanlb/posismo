class CreateAccountManagements < ActiveRecord::Migration
  def self.up
    create_table :account_managements do |t|
      t.integer :admin_id
      t.integer :client_id

      t.timestamps
    end
  end

  def self.down
    drop_table :account_managements
  end
end
