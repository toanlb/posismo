class CreateDailies < ActiveRecord::Migration
  def self.up
    create_table :dailies do |t|
      t.references :publish
      t.references :partner
      t.references :site
      t.references :client
      t.references :promotion
      t.integer :impression_count
      t.integer :click_count
      t.integer :click_rate
      t.integer :final_click_reward
      t.integer :order_count
      t.integer :conversion_rate
      t.integer :final_order_count
      t.integer :cancel_order_count
      t.integer :plan_order_reward
      t.integer :final_order_reward
      t.integer :final_all_reward
      t.date :created_on

      t.timestamps
    end
  end

  def self.down
    drop_table :dailies
  end
end
