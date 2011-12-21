class DeletePromotionIdFromParameters < ActiveRecord::Migration
  def self.up
    remove_column :parameters, :promotion_id
  end

  def self.down
    add_column :parameters, :promotion_id, :integer, :after => "asp_id"
  end
end
