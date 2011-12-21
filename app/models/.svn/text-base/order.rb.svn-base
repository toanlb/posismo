# encoding: utf-8
class Order < ActiveRecord::Base
  
  belongs_to :publish
  belongs_to :click
  has_one :banner
  
  STATUS_FLAGS = %w(承認待ち 承認 非承認 保留).freeze
  scope :sort_by_name_asc, order('name ASC')
  scope :sort_by_name_desc, order('name DESC')
  scope :sort_by_promotion_name_asc, order('promotion_name ASC')
  scope :sort_by_promotion_name_desc, order('promotion_name DESC')
  scope :sort_by_login_id_asc, order('login_id ASC')
  scope :sort_by_login_id_desc, order('login_id DESC')
  scope :sort_by_banner_name_asc, order('banner_name ASC')
  scope :sort_by_banner_name_desc, order('banner_name DESC')
  scope :sort_by_manager_name_asc, order('manager_name ASC')
  scope :sort_by_manager_name_desc, order('manager_name DESC')
  scope :sort_by_add_data_asc, order('add_data ASC')
  scope :sort_by_add_data_desc, order('add_data DESC')
  scope :sort_by_click_updated_at_asc, order('click_updated_at ASC')
  scope :sort_by_click_updated_at_desc, order('click_updated_at DESC')

  validates :status_flag, :inclusion => { :in => STATUS_FLAGS }

  scope :by_client, lambda {|client|
    joins(:publish => :promotion).
      where(["promotions.client_id = ?", client.id])
  }

  scope :by_client_for_sites, lambda {|client|
    joins(:publish => :promotion ).
    joins("LEFT JOIN sites ON publishes.site_id = sites.id").
    joins("LEFT JOIN partners ON sites.partner_id = partners.id").
    joins("LEFT JOIN asps ON publishes.asp_id = asps.id").
    joins("LEFT JOIN banners ON orders.banner_id = banners.id").
    joins("LEFT JOIN clicks ON orders.click_id = clicks.id").
    where(["promotions.client_id = ?", client.id]).
    select("orders.id").
    select("orders.banner_id").
    select("orders.created_at").
    select("orders.decide_date").
    select("orders.status_flag").
    select("orders.price").
    select("orders.gross_price").
    select("orders.net_price").
    select("orders.gross_rate").
    select("orders.net_rate").
    select("orders.remote_address").
    select("orders.referer").
    select("orders.metadata").
    select("orders.add_data").
    select("orders.updated_at").
    select("CASE WHEN asps.id IS NULL THEN sites.name ELSE asps.name END as name").
    select("partners.login_id").
    select("promotions.name promotion_name").
    select("partners.manager_name").
    select("banners.name banner_name").
    select("clicks.updated_at click_updated_at")
  }
  
  scope :by_partner, lambda {|partner|
    joins(:publish => :promotion ).
    joins("LEFT JOIN sites ON publishes.site_id = sites.id").
    joins("LEFT JOIN partners ON sites.partner_id = partners.id").
    joins("LEFT JOIN banners ON orders.banner_id = banners.id").
    joins("LEFT JOIN clicks ON orders.click_id = clicks.id").
    where(["sites.partner_id = ?", partner.id]).
    select("orders.id").
    select("orders.banner_id").
    select("orders.created_at").
    select("orders.decide_date").
    select("orders.status_flag").
    select("orders.price").
    select("orders.gross_price").
    select("orders.net_price").
    select("orders.gross_rate").
    select("orders.net_rate").
    select("orders.remote_address").
    select("orders.referer").
    select("orders.metadata").
    select("orders.add_data").
    select("orders.updated_at").
    select("sites.name name").
    select("partners.login_id").
    select("promotions.name promotion_name").
    select("partners.manager_name").
    select("banners.name banner_name").
    select("clicks.updated_at click_updated_at")
  }
  
  scope :by_partner_site, lambda {|partner|
    joins(:publish => :site).
      where(["sites.partner_id = ?", partner.id])
  }

  scope :adjusted, where("adjusted = ?", true)

  def status_flag
    STATUS_FLAGS[read_attribute(:status_flag)]
  end
  def status_flag=(data)
    write_attribute(:status_flag, STATUS_FLAGS.index(data))
  end

  attr_protected :status_flag

  def approved?
    self.status_flag == "承認"
  end

  def approve!
    self.status_flag = "承認"
    self.decide_date = Date.parse(Time.new.to_s)
    self.save!
  end
  
  def rejected?
    self.status_flag == "非承認"
  end

  def reject!
    self.status_flag = "非承認"
    self.decide_date = Date.parse(Time.new.to_s)
    self.save!
  end

  def defer?
    self.status_flag == "保留"
  end

  def defer!
    self.status_flag = "保留"
    self.decide_date = nil
    self.save!
  end

  def pending_approved?
    self.status_flag == "承認待ち"
  end
  
  def confirmed?
    if self.status_flag == "承認待ち"
      return false
    else
      return true
    end
  end
  
  def self.status_flag_index(status_flag)
    index = 3;
    STATUS_FLAGS.each_with_index do|value, ind|
       if status_flag == value
         index = ind
       end
    end

    return index
  end

  def approve_update_daily!
    if self.banner_id.nil?
      daily = Daily.by_daily_publish(self.publish_id, self.created_on).first
    else
      daily = Daily.by_daily_publish_banner(self.publish_id, self.banner_id, self.created_on).first
    end
    if daily.present?
      if pending_approved? || defer?
        daily.add_gross_price(self.gross_price)
        daily.add_net_price(self.net_price)
        daily.add_final_count
        daily.save!
      elsif rejected?
        daily.add_gross_price(self.gross_price)
        daily.add_net_price(self.net_price)
        daily.add_final_count
        daily.delete_cancel_count
        daily.save!
      end
    end
  end

  def reject_update_daily!
    if self.banner_id.nil?
      daily = Daily.by_daily_publish(self.publish_id, self.created_on).first
    else
      daily = Daily.by_daily_publish_banner(self.publish_id, self.banner_id, self.created_on).first
    end

    if daily.present?
      if pending_approved? || defer?
        daily.add_cancel_count
        daily.save!
      elsif approved?
        daily.delete_gross_price(self.gross_price)
        daily.delete_net_price(self.net_price)
        daily.add_cancel_count
        daily.delete_final_count
        daily.save!
      end
    end
  end

  def defer_update_daily!
    if self.banner_id.nil?
      daily = Daily.by_daily_publish(self.publish_id, self.created_on).first
    else
      daily = Daily.by_daily_publish_banner(self.publish_id, self.banner_id, self.created_on).first
    end
    if daily.present?
      if approved?
        daily.delete_gross_price(self.gross_price)
        daily.delete_net_price(self.net_price)
        daily.delete_final_count
        daily.save!
      elsif rejected?
        daily.delete_cancel_count
        daily.save!
      end
    end
  end
end
