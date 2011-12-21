# encoding: utf-8
require 'csv'

class Partner::OrdersController < Admin::OrdersController

  layout 'partner'

  skip_before_filter :authenticate_admin!
  skip_before_filter :authority_required
  skip_before_filter :find_client 
  before_filter :authenticate_partner!, :except => [:pointback]
  before_filter :find_partner, :except => [:pointback]
  before_filter :find_partner_by_params, :only => [:pointback]

  def index
    #デフォルトソート設定
    if params[:search].nil?
      params[:search] = {:meta_sort => 'created_at.desc'}
    else if params[:search][:meta_sort].nil?
        params[:search][:meta_sort]='created_at.desc'
      end
    end
    @selected_promotions = []
    if params[:publishList].nil?
      @search = Order.by_partner(@partner).search(params[:search])
    else
      @search = Order.by_partner(@partner).where("promotions.id IN (?)",params[:publishList][:promotion_id_in]).search(params[:search])
      @selected_promotions = params[:publishList][:promotion_id_in]
    end
    @orders = @search.page(params[:page]).per(params[:per])
    promotion_ids = []
    @partner.publishes.each do |publish|
      promotion_ids << publish.promotion_id
    end
    @promotions_for_select = Promotion.find promotion_ids
    
    respond_to do |format|
      format.html
    end
  end
  
  def csv
    @search = Order.by_partner(@partner).search(params[:search])

    header = %w(注文ID プロモーション名 サイト名 ptサイトデータ 報酬額 クリック時刻 注文日 確定日 ステータス)
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << header.map{|head| head.encode("CP932")}
          @search.each do |row|
            csv << [row.id,
              row.promotion_name,
              row.name,
              row.add_data,
              row.net_price,
              row.click_updated_at.nil? ? "" : row.click_updated_at.strftime("%Y/%m/%d"),
              row.created_at.strftime("%Y/%m/%d"),
              row.decide_date.nil? ? nil : row.decide_date.strftime("%Y/%m/%d"),
              row.status_flag
              ]
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => "orders.csv")
      end
    end
  end
  
  def pointback
    start_date = Time.gm(params[:year], params[:month], params[:day])
    end_date = start_date + 1.day - 1.second
    start_date += params[:ds].to_i.days if params[:ds].to_i < 0
    end_date += params[:ds].to_i.days if params[:ds].to_i > 0
    
    date_col = params[:type].to_i == 1 ? "decide_date" : "created_on"
    @orders = Order.
      by_partner_site(@partner).
      includes({:publish => [:promotion, :site]}).
      where(
        "orders.status_flag = :type AND orders.#{date_col} BETWEEN :start_date AND :end_date",
        {
          :type => params[:type],
          :start_date => start_date,
          :end_date => end_date,
        }
      )
    @orders = @orders.where("sites.id = :site_id", :site_id => params[:pid]) unless params[:pid].nil?
    respond_to do |format|
      format.csv do
        op = params[:op].nil? ? 1 : params[:op].to_i
        unless @orders.blank?
          header = %w(ユーザー会員ID 広告ID 広告名 承認状況 発生日 確定日 金額 報酬 サイトID オーダーユニークID)
          header = header.map{|head| head.encode("CP932")}
          csv_data = CSV.generate({
            # パラメータsepが1ならタブ区切り、デフォルトはカンマ区切り
            :col_sep => params[:sep].to_i == 1 ? "\t" : ",",
            # パラメータhが1だったらヘッダ出力
            :write_headers => params[:h].to_i == 1,
            :headers => header,
            # パラメータopが2か3なら、"で各項目を強制的に囲う
            :force_quotes => [2,3].detect{|x| x == op}
          }) do |csv|
            @orders.each do |order|
              promotion_name = order.publish.promotion.name.encode("CP932")
              row = [order.add_data, order.publish.promotion_id, promotion_name, Order::STATUS_FLAGS.index(order.status_flag), order.created_on, order.decide_date, order.price, order.net_price, order.publish.site.id, order.id]
              # パラメータopが1か3ならデータ中の","を全角に変換する
              row.map! do |item|
                item.nil? ? nil : item.to_s.gsub(/,/, "，")
              end if [1,3].detect{|x| x == op}
              
              csv << row
            end
          end
        end
        send_data(csv_data, :type => 'text/csv', :filename => "orders.txt")
        #render :text => csv_data
      end
    end
  end

protected
  def find_partner
     @partner = current_partner
  end

  def find_partner_by_params
     @partner = Partner.find_by_login_id(params[:name])
     raise ActiveRecord::RecordNotFound if @partner.nil? || !@partner.valid_password?(params[:pass])
  end

  def csv_name
    "#{params[:controller]}.csv"
  end
end