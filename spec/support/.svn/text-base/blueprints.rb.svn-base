# encoding: utf-8
require 'machinist/active_record'

Admin.blueprint do
  login_id {"admin_#{Time.now.to_i.to_s + sn}"}
  name {"admin_#{Time.now.to_i.to_s + sn}"}
  password {"password"}
  password_confirmation {"password"}
  email {"tech+2pm+#{Time.now.to_i.to_s + sn}@itokuro.jp"}
end

Admin.blueprint(:super_user) do
  login_id {"admin_#{Time.now.to_i.to_s + sn}"}
  name {"admin_#{Time.now.to_i.to_s + sn}"}
  password {"password"}
  password_confirmation {"password"}
  email {"tech+2pm+#{Time.now.to_i.to_s + sn}@itokuro.jp"}
  super_user {true}
end

Client.blueprint do
  login_id {"client_#{Time.now.to_i.to_s + sn}" }
  email { "#{object.login_id}@example.com" }
  password {"password"}
  password_confirmation {"password"}
  site_name {"イトクロ技術部"}
  site_url {"http://itokuro.jp"}
  company_name {"株式会社イトクロ"}
  company_name_kana {"カブシキガイシャイトクロ"}
  contractor_department {"技術部"}
  contractor_position {"部長"}
  contractor_name {"大川"}
  contractor_name_kana {"オオカワ"}
  manager_department {"技術部"}
  manager_position {"社員"}
  manager_name {"金ヒョンジン"}
  manager_name_kana {"キムヒョンジン"}
  postal_code {"107-0052"}
  address {"東京都港区赤坂1-6-14赤坂協和ビル3F"} 
  tel {"03-6230-1096"} 
end

Partner.blueprint do
  login_id {"partner_#{Time.now.to_i.to_s + sn}" }
  email {"#{object.login_id}@example.com"}
  password {"password"}
  password_confirmation {"password"}
  manager_name {"金ヒョンジン"}
  manager_name_kana {"キムヒョンジン"}
  postal_code {"107-0052"}
  address {"東京都港区赤坂1-6-14赤坂協和ビル3F"} 
  tel {"03-6230-1096"}
end

Partner.blueprint(:individual) do
  contract_type { Partner::CONTRACT_TYPES.index("個人") }
end

Promotion.blueprint do
  active { true }
  starts_at { DateTime.current } 
  name { "Promotion_#{Time.now.to_i.to_s + sn}" }
  url { "http://example.com/#{object.name}" }
  description { "description of #{object.name}" }
  rewards(1, :basic_fixed)
end

Promotion.blueprint(:consigned) do
  rewards(1, :basic_fixed_consigned)
end
# デフォルトでは 非受託・基本・固定報酬
Reward.blueprint do
  gross_price { rand(21) * 1000 }
  starts_at { DateTime.current }
  ends_at { object.starts_at + (1 + rand(30).days) }
  reward_type { Reward::TYPES.index("基本報酬") }
  price_type { Reward::PRICE_TYPES.index("固定報酬") }
end

# 非受託・基本固定報酬
Reward.blueprint(:basic_fixed) do
  reward_type { Reward::TYPES.index("基本報酬") }
  price_type { Reward::PRICE_TYPES.index("固定報酬") }
end

# 非受託・キャンペーン固定報酬
Reward.blueprint(:campaign_fixed) do
  reward_type { Reward::TYPES.index("キャンペーン報酬") }
end

# 非受託・基本料率報酬
Reward.blueprint(:basic_rate) do
  gross_rate { rand(21) * 5 }
  price_type { Reward::PRICE_TYPES.index("料率報酬") }
end

# 非受託・キャンペーン料率報酬
Reward.blueprint(:campaign_rate) do
  gross_rate { rand(21) * 5 }
  reward_type { Reward::TYPES.index("キャンペーン報酬") }
  price_type { Reward::PRICE_TYPES.index("料率報酬") }
end

# 受託・基本固定報酬
Reward.blueprint(:basic_fixed_consigned) do
  gross_price { rand(21) * 1000 }
  net_price { (0.6 * object.gross_price).to_i }
end

# 受託・キャンペーン固定報酬
Reward.blueprint(:campaign_fixed_consigned) do
  gross_price { rand(21) * 1000 }
  net_price { (0.6 * object.gross_price).to_i }
  reward_type { Reward::TYPES.index("キャンペーン報酬") }
end

# 受託・基本料率報酬
Reward.blueprint(:basic_rate_consigned) do
  gross_rate { rand(21) * 5 }
  net_rate { (0.6 * object.gross_rate).to_i }
  price_type { Reward::PRICE_TYPES.index("料率報酬") }
end

# 受託・キャンペーン料率報酬
Reward.blueprint(:campaign_rate_consigned) do
  gross_rate { rand(21) * 5 }
  net_rate { (0.6 * object.gross_rate).to_i }
  reward_type { Reward::TYPES.index("キャンペーン報酬") }
  price_type { Reward::PRICE_TYPES.index("料率報酬") }
end

ClickReward.blueprint do
  price { rand(21) * 5 } 
  starts_at { 1.minutes.from_now}
end

Site.blueprint do
  name {"site_#{Time.now.to_i.to_s + sn}" }
  url { "http://#{object.name}.example.com/" }
  description { "Description of #{object.name}" }
  keywords { "keywords_of_#{object.name}" }
end

Order.blueprint do
  publish_id{1}
  click_id{1}
  remote_address{"122.216.22.82"}
  referer{"http://hq-sv-v-0008.itokuro.local/php/conversion.html"}
  metadata{}
  price{1000}
  gross_price{2000}
  net_price{1500}
  gross_rate{20.0}
  net_rate{10.0}
  add{}
  created_on{"2011-7-1"}
end

Daily.blueprint do
  publish_id{1}
  partner_id{1}
  site_id{1}
  client_id{1}
  promotion_id{1}
  asp_id{1}
  impression_count{50}
  click_count{50}
  click_valid_count{30}
  click_rate{10}
  final_click_reward{3000}
  plan_order_count{40}
  final_order_count{50}
  cancel_order_count{60}
  plan_order_reward{70}
  final_order_reward{80}
  final_all_reward{90}
end

Notice.blueprint do
  # Attributes here
end

Banner.blueprint do
  # Attributes here
end

ImageBanner.blueprint do
  # Attributes here
end

Convert.blueprint do
  # Attributes here
end

AccountManagement.blueprint do
  # Attributes here
end
