class ChengeActiveToPromotions < ActiveRecord::Migration
  def self.up
    Promotion.activated.each do |p|
      p.deactivate! unless p.basic_reward
    end
  end

  def self.down
  end
end
