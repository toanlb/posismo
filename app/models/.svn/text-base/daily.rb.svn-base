# encoding: utf-8
class Daily < ActiveRecord::Base
  belongs_to :client
  belongs_to :partner
  belongs_to :publish
  belongs_to :site
  belongs_to :promotion

  HEADER = %w(注文日 表示回数 クリック数 有効クリック数 クリック率 クリック報酬 コンバージョン率 注文数 注文確定数 注文キャンセル数 予定報酬 NET予定報酬 確定注文報酬 NET確定注文報酬 確定合計報酬 NET確定合計報酬)

  scope :sort_by_sum_impression_count_asc, order('sum_impression_count ASC')
  scope :sort_by_sum_impression_count_desc, order('sum_impression_count DESC')
  scope :sort_by_sum_click_count_asc, order('sum_click_count ASC')
  scope :sort_by_sum_click_count_desc, order('sum_click_count DESC')
  scope :sort_by_sum_click_valid_count_asc, order('sum_click_valid_count ASC')
  scope :sort_by_sum_click_valid_count_desc, order('sum_click_valid_count DESC')
  scope :sort_by_sum_click_rate_asc, order('sum_click_rate ASC')
  scope :sort_by_sum_click_rate_desc, order('sum_click_rate DESC')
  scope :sort_by_sum_final_click_reward_asc, order('sum_final_click_reward ASC')
  scope :sort_by_sum_final_click_reward_desc, order('sum_final_click_reward DESC')
  scope :sort_by_sum_conversion_rate_asc, order('sum_conversion_rate ASC')
  scope :sort_by_sum_conversion_rate_desc, order('sum_conversion_rate DESC')
  scope :sort_by_sum_plan_order_count_asc, order('sum_plan_order_count ASC')
  scope :sort_by_sum_plan_order_count_desc, order('sum_plan_order_count DESC')
  scope :sort_by_sum_final_order_count_asc, order('sum_final_order_count ASC')
  scope :sort_by_sum_final_order_count_desc, order('sum_final_order_count DESC')
  scope :sort_by_sum_cancel_order_count_asc, order('sum_cancel_order_count ASC')
  scope :sort_by_sum_cancel_order_count_desc, order('sum_cancel_order_count DESC')
  scope :sort_by_sum_plan_order_reward_asc, order('sum_plan_order_reward ASC')
  scope :sort_by_sum_plan_order_reward_desc, order('sum_plan_order_reward DESC')
  scope :sort_by_sum_plan_order_net_reward_asc, order('sum_plan_order_net_reward ASC')
  scope :sort_by_sum_plan_order_net_reward_desc, order('sum_plan_order_net_reward DESC')
  scope :sort_by_sum_final_order_reward_asc, order('sum_final_order_reward ASC')
  scope :sort_by_sum_final_order_reward_desc, order('sum_final_order_reward DESC')
  scope :sort_by_sum_final_order_net_reward_asc, order('sum_final_order_net_reward ASC')
  scope :sort_by_sum_final_order_net_reward_desc, order('sum_final_order_net_reward DESC')
  scope :sort_by_sum_final_all_reward_asc, order('sum_final_all_reward ASC')
  scope :sort_by_sum_final_all_reward_desc, order('sum_final_all_reward DESC')
  scope :sort_by_sum_final_all_net_reward_asc, order('sum_final_all_net_reward ASC')
  scope :sort_by_sum_final_all_net_reward_desc, order('sum_final_all_net_reward DESC')
  scope :sort_by_year_month_asc, order('year(dailies.created_on) ASC ,month(dailies.created_on) ASC')
  scope :sort_by_year_month_desc, order('year(dailies.created_on) DESC ,month(dailies.created_on) DESC')
  scope :sort_by_partners_count_asc, order('partners_count ASC')
  scope :sort_by_partners_count_desc, order('partners_count DESC')
  
  scope :by_daily_publish, lambda {|publish_id, created_on|
    where(["publish_id = ? AND created_on = ?", publish_id, created_on])
  }

  scope :by_daily_publish_banner, lambda {|publish_id, banner_id, created_on|
    where(["publish_id = ? AND banner_id = ? AND created_on = ?", publish_id, banner_id, created_on])
  }

  def add_gross_price(order_price)
    self.final_order_reward += order_price
    self.final_all_reward += order_price
  end

  def add_net_price(order_price)
    self.final_order_net_reward += order_price
    self.final_all_net_reward += order_price
  end

  def add_final_count
    self.final_order_count += 1
  end

  def add_cancel_count
    self.cancel_order_count += 1
  end

  def delete_gross_price(order_price)
    self.final_order_reward -= order_price
    self.final_all_reward -= order_price
  end

  def delete_net_price(order_price)
    self.final_order_net_reward -= order_price
    self.final_all_net_reward -= order_price
  end

  def delete_final_count
    self.final_order_count -= 1
  end

  def delete_cancel_count
    self.cancel_order_count -= 1
  end
  
  def promotion_name=(name)
    return name
  end
  
  def partner_count=(count)
    return count
  end
  
  def self.header_to_sjis()
    HEADER.map{|header| header.encode("CP932")}
  end

end
