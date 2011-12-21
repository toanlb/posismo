class Asp < ActiveRecord::Base
  belongs_to :client
  has_many :publishes
  has_many :promotions, :through => :publishes

  validates :name, :presence => true
  validates :tag, :presence => true
  
  scope :sort_by_click_url_asc, order('publishes.id ASC')
  scope :sort_by_click_url_desc, order('publishes.id DESC')
  
  scope :left_join_publishes, lambda {|promotion_id=nil|
    joins_param = ["LEFT JOIN publishes ON publishes.asp_id = asps.id"]
    unless promotion_id.nil?
      joins_param[0] += " AND publishes.promotion_id = "
      joins_param[1] = promotion_id
    end
    joins(joins_param)
  }

  def associated_promotion?(promotion_id)
    self.publishes.detect{|publish|publish.promotion_id == promotion_id}
  end
  
  def associated_promotion(promotion_id)
    self.publishes.select{|publish|publish.promotion_id == promotion_id}
  end
end
