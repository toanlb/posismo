# encoding: utf-8
class Promotion < ActiveRecord::Base
  include ActiveModel::Dirty
  TIEUP_TYPES = ["承認しない","承認する"]
  LISTING_TYPES = ["一切不可","一部OK","全て可"]
  ENABLE_ADDS = ["一般サイトのみ","ポイントサイトのみ"]
  default_scope :conditions => { :deleted => false }

  belongs_to :client
  has_many :publishes
  has_many :sites, :through => :publishes, :conditions => { "publishes.deleted" => false }
  has_many :orders, :through => :publishes, :conditions => { "publishes.deleted" => false }
  has_many :asps, :through => :publishes, :conditions => { "publishes.deleted" => false }
  has_many :rewards, :dependent => :destroy
  has_one :click_reward, :dependent => :destroy
  has_one :basic_reward, :class_name => "Reward", :conditions => { :reward_type => Reward::TYPES.index("基本報酬") }
  has_many :campaign_rewards, :class_name => "Reward", :conditions => { :reward_type => Reward::TYPES.index("キャンペーン報酬") }
  has_many :categories_promotions
  has_many :categories, :through => :categories_promotions
  has_many :banners
  has_many :image_banners
  has_many :text_banners
  
  accepts_nested_attributes_for :click_reward
  accepts_nested_attributes_for :categories_promotions

  validates :name, :presence => true
  validates :url, :presence => true, :format => URI.regexp(['http', 'https'])

  scope :activated, where(:active => true, :opened => true)
  
  scope :partners_count_scope,lambda{|promotion|
    joins(:publishes => {:site => :partner})
            .where("publishes.deleted = 0")
            .where("sites.deleted = 0")
            .where("partners.deleted = 0")
            .where(["promotions.id = ?", promotion.id])
            .group("partners.id")
            .select("COUNT(*)")
  }

  scope :partners_scope,lambda{|promotion|
    joins(:publishes => {:site => :partner})
            .where("publishes.deleted = 0")
            .where("sites.deleted = 0")
            .where("partners.deleted = 0")
            .where(["promotions.id = ?", promotion.id])
            .group("partners.id")
            .select("DISTINCT partners.*")
  }

  # 基本報酬が設定されている時のみ有効に
  def activate!
    if self.basic_reward
      self.active = true
      self.save
    end
  end

  def deactivate!
    self.active = false
    self.save
  end

  def toggle_activate!
    self.active? ? deactivate! : activate!
  end
  # siteと提携する
  def publish!(site)
    self.publishes.create(:site => site) unless self.sites.include?(site)
  end
  
  # 受託クライアントのプロモションか？
  def belongs_to_consigned_client?
    !!self.client && self.client.consigned?
  end
  
  def self.publishes_sites_options_for_select(client_id, promotion_id)
    options = []
    promotion = self.where("client_id = ?", client_id).find_by_id(promotion_id)
    publishes = promotion.publishes.includes(:site)
    publishes.each do |publish|
      options << [publish.site.name, publish.site.id] unless publish.site.nil?
    end
    
    options
  end
  
  def self.sites_options_for_select(client_id, promotion_ids)
    sites = []
    site_options = []
      promotions = self.where("client_id = ?", client_id).where('id IN (?) ', promotion_ids)
      promotions.each do |promotion|
        sites << promotion.sites
      end
      sites = sites.flatten
      sites.uniq.each do |site|
        unless site.nil?
            site_options << [site.name, site.id]
        end
      end

    return site_options
  end
  
  def partners_count
    promotion = Promotion.partners_count_scope self

    return promotion.all.count
  end
  
  def partners
    Promotion.partners_scope self
  end
  
  def check_related_publishes
    if self.deleted_changed?
      self.publishes.each do |publish|
        if self.deleted == true
          publish.deleted = true
          publish.save
        else if self.deleted == false
            publish.deleted = false
            publish.save
          end
        end
      end
    end
  end
  
end
