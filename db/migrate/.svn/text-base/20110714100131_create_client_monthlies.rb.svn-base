class CreateClientMonthlies < ActiveRecord::Migration
  def self.up
    create_table :client_monthlies do |t|
      t.integer :client_id
      t.string  :login_id
      t.string  :company_name
      t.string  :manager_name
      t.integer :charge
      t.integer :count_partner
      t.string  :month

      t.timestamps
    end
    add_index :client_monthlies, :login_id
    add_index :client_monthlies, :month
  end

  def self.down
    drop_table :client_monthlies
  end
end
