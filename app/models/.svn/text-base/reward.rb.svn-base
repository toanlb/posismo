# encoding: utf-8
class Reward < ActiveRecord::Base
  ################
  #### Constants
  TYPES = %w(基本報酬 キャンペーン報酬).freeze
  PRICE_TYPES = %w(固定報酬 料率報酬).freeze
  belongs_to :promotion

  ###############
  #### Validation
  validates :gross_price, :presence => true, :numericality => {:only_integer => true}, :if => :fixed_price?
  validates :net_price, :presence => true, :numericality => {:only_integer => true}, :if => [:fixed_price?, :belongs_to_consigned_client?]
  validates :gross_rate, :presence => true, :numericality => true, :if => :rate_price?
  validates :net_rate, :presence => true, :numericality => true, :if => [:rate_price?, :belongs_to_consigned_client?]
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true, :if => :campaign?
  validate :ends_at_must_be_later_than_starts_at, :unless => :basic?
  validate :campaign_period_must_not_be_overlap_with_others, :if => [:campaign?], :unless => ["starts_at.blank?", "ends_at.blank?"]
  validate :only_one_basic_reward, :if => :basic?, :on => :create
  
  scope :ends_at_nil, where(["reward_type = ? && ends_at IS NULL", Reward::TYPES.index("基本報酬")])
  scope :basic_reward, where( :reward_type => Reward::TYPES.index("基本報酬") )
  scope :campaign_rewards, where( :reward_type => Reward::TYPES.index("キャンペーン報酬") )
  #### Callbacks
  after_destroy :promotion_deactivate!

  def basic?
    self.reward_type && self.reward_type == Reward::TYPES.index("基本報酬")
  end

  def campaign?
    self.reward_type && self.reward_type == Reward::TYPES.index("キャンペーン報酬")
  end

  def rate_price?
    self.price_type && self.price_type == Reward::PRICE_TYPES.index("料率報酬")
  end

  def fixed_price?
    self.price_type && self.price_type == Reward::PRICE_TYPES.index("固定報酬")
  end

  def belongs_to_consigned_client?
    !!self.promotion && self.promotion.belongs_to_consigned_client?
  end

protected
  def ends_at_must_be_later_than_starts_at
    if starts_at && ends_at&& ends_at <= starts_at
      errors.add(:ends_at, "終了時刻は開示時刻よりあとにしてください。")
    end
  end

  def campaign_period_must_not_be_overlap_with_others
    unless promotion.campaign_rewards.where(:ends_at => starts_at..ends_at).where("id <> ?", id).limit(1).empty?
      errors.add(:starts_at, "が別のキャンペーン期間内です。")
    end
    unless promotion.campaign_rewards.where(:starts_at => starts_at..ends_at).where("id <> ?", id).limit(1).empty?
      errors.add(:ends_at, "が別のキャンペーン期間内です。")
    end
  end

  def only_one_basic_reward
    if promotion && !promotion.basic_reward.blank?
      errors.add(:reward_type, "：基本報酬は1つのみ登録可能です。")
    end
  end

  def promotion_deactivate!
    self.promotion.deactivate! if self.basic?
  end
end