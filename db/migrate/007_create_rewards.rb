class CreateRewards < ActiveRecord::Migration
  def self.up
    create_table :rewards do |t|
      t.references :promotion
      t.integer :price
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
    
    create_table :click_rewards do |t|
      t.references :promotion
      t.integer :price
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end

  def self.down
    drop_table :rewards
    drop_table :click_rewards
  end
end
