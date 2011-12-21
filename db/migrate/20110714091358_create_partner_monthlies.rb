class CreatePartnerMonthlies < ActiveRecord::Migration
  def self.up
    create_table :partner_monthlies do |t|
      t.integer :partner_id
      t.string  :login_id
      t.string  :company_name
      t.string  :manager_name
      t.integer :gross_price
      t.integer :net_price
      t.string  :month

      t.timestamps
    end
    add_index :partner_monthlies, :login_id
    add_index :partner_monthlies, :month
  end

  def self.down
    drop_table :partner_monthlies
  end
end
