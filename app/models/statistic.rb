# encoding: utf-8
class Statistic < ActiveRecord::Base
  set_table_name "dailies"
  belongs_to :client
  belongs_to :partner
  belongs_to :publish
  belongs_to :site
  belongs_to :promotion

  ADMIN_HEADER = %w(注文日 表示回数 クリック数 有効クリック数 クリック率 クリック報酬 コンバージョン率 注文数 注文確定数 注文キャンセル数 予定報酬 NET予定報酬 確定注文報酬 NET確定注文報酬 確定合計報酬 NET確定合計報酬)
  HEADER = %w(注文日 表示回数 クリック数 有効クリック数 クリック率 クリック報酬 コンバージョン率 注文数 注文確定数 注文キャンセル数 予定報酬 確定注文報酬 確定合計報酬)
  CONSIGNED_HEADER = %w(注文日 表示回数 クリック数 有効クリック数 クリック率 クリック報酬 コンバージョン率 注文数 注文確定数 注文キャンセル数)

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


  scope :by_daily_publish, lambda {|publish_id, created_on|
    where(["publish_id = ? AND created_on = ?", publish_id, created_on])
  }

  scope :by_daily_publish_banner, lambda {|publish_id, banner_id, created_on|
    where(["publish_id = ? AND banner_id = ? AND created_on = ?", publish_id, banner_id, created_on])
  }

  def self.admin_header_to_sjis()
    ADMIN_HEADER.map{|header| header.encode("CP932")}
  end
  
  def self.header_to_sjis()
    HEADER.map{|header| header.encode("CP932")}
  end

  def self.consigned_header_to_sjis()
    CONSIGNED_HEADER.map{|header| header.encode("CP932")}
  end
end
