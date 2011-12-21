class DeletePartnerships < ActiveRecord::Migration
  def self.up
    drop_table :partnerships
  end

  def self.down
    create_table :partnerships do |t|
      t.references :promotion
      t.references :asp

      t.timestamps
    end
  end
end
