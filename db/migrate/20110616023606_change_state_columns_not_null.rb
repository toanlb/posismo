class ChangeStateColumnsNotNull < ActiveRecord::Migration
  def self.up
    change_column_null(:partners, :contract_type, null = false, default = 0)
    change_column_null(:partners, :payment_type, null = false, default = 0)
    change_column_null(:clients, :registration_status, null = false, default = 0)
  end

  def self.down
    change_column_null(:partners, :contract_type, null = true, default = 0)
    change_column_null(:partners, :payment_type, null = true, default = 0)
    change_column_null(:clients, :registration_status, null = true, default = 0)
  end
end
