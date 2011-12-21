class ClickReward < ActiveRecord::Base
  belongs_to :promotion
  
  validates :price, :presence => true, :numericality => {:only_integer => true}
end
