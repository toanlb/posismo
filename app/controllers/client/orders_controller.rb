# encoding: utf-8
require 'csv'
class Client::OrdersController < Admin::OrdersController

  layout 'client'

  skip_before_filter :authenticate_admin!
  skip_before_filter :authority_required  
  before_filter :authenticate_client!
  before_filter :find_client 


  def approve
    check_ids_except_approval_status!
    super
  end

  def reject
    check_ids_except_approval_status!
    super
  end
  
  def defer
    check_ids_except_approval_status!
    super
  end
  
  def csv
    #デフォルトソート設定
    if params[:search].nil?
      params[:search] = {:meta_sort => 'created_at.desc'}
    else if params[:search][:meta_sort].nil?
        params[:search][:meta_sort]='created_at.desc'
      end
    end
    if params[:publishList].nil?
      @orders = Order.by_client_for_sites(@client).search(params[:search])
    else
      @orders = Order.by_client_for_sites(@client).where("promotions.id IN (?)",params[:publishList][:promotion_id_in]).search(params[:search])
    end

    header = %w(注文ID 注文状況記号 注文状況 注文時刻 確定日 プロモーション名 サイト名/ASP名 バナー名 価格 グロス価格 グロスレート ptサイトデータ)
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << header.map{|head| head.encode("CP932")}
          @orders.each do |row|
            csv << [row.id,
             Order.status_flag_index(row.status_flag),
             row.status_flag, 
             row.created_at.strftime("%Y年%m月%d日:%X"),
             row.decide_date.nil? ? nil : row.decide_date.strftime("%Y年%m月%d日"),
             row.promotion_name, 
             row.name, 
             row.banner_name, 
             row.price, 
             row.gross_price, 
             row.gross_rate, 
             row.add_data]
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => "order.csv")
      end
    end
  end
protected
  def find_client 
     @client = current_client
  end

  def csv_name
    "#{params[:controller]}.csv"
  end

  def check_ids_except_approval_status!
    unless params[:check_ids].nil?
      check_ids = []
      Order.
        where(["orders.id IN (?)", params[:check_ids]]).
        where(["orders.status_flag NOT IN (?)", [Order::STATUS_FLAGS.index("承認"), Order::STATUS_FLAGS.index("非承認")]]).
        each do |order|
          check_ids << order.id
      end

      params[:check_ids] = check_ids.empty? ? nil : check_ids
    end
  end
end