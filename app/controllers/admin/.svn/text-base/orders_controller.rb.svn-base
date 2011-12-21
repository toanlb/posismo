# -*- coding: utf-8 -*-
require 'csv'
class Admin::OrdersController < ApplicationController

  layout 'admin'

  before_filter :authenticate_admin!  
  before_filter :find_client 
  before_filter :declare_consigned_work!
  before_filter :authority_required
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
      @search = Order.by_client_for_sites(@client).search(params[:search])
    else
      @search = Order.by_client_for_sites(@client).where("promotions.id IN (?)",params[:publishList][:promotion_id_in]).search(params[:search])
      @selected_promotions = params[:publishList][:promotion_id_in]
    end
    @orders = @search.page(params[:page]).per(params[:per])
    @promotions_for_select = @client.promotions

    respond_to do |format|
      format.html
    end
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

    header = %w(注文ID 注文状況記号 注文状況 注文時刻 確定日 プロモーション名 サイト名/ASP名 バナー名 価格 グロス価格 ネット価格 グロスレート ネットレート ptサイトデータ)
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
             row.net_price, 
             row.gross_rate, 
             row.net_rate,
             row.add_data]
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => "order.csv")
      end
    end
  end

  def new
    @order = Order.new({:price => nil, :gross_price => nil, :net_price => nil, :gross_rate => nil, :net_rate => nil})

    @promotions = @client.promotions.joins(:publishes).order(:id).uniq

    @sites = []
    @client.promotions.first.
      publishes.order(:site_id).includes(:site).
      each do |p|
        @sites.push(p.site) unless p.site.nil?
    end
    @sites = @sites.uniq

  end

  def create
    @order = Order.new(params[:order])
    @order.status_flag = params[:order][:status_flag]
    @order.publish_id = Publish.
      where("promotion_id = ?", params[:publishList][:promotion_id]).
      where("site_id = ?", params[:publishList][:site_id]).
      first.try(:id)
    @order.adjusted = true
    @order.status_flag = "承認"
    @order.decide_date = Date.parse(Time.new.to_s)

    respond_to do |format|
      if @order.save!
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to :action => "index" }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @order = Order.by_client(@client).adjusted.find(params[:id])

    @promotions = @client.promotions.joins(:publishes).order(:id).uniq

    @sites = []
    @client.promotions.find_by_id(@order.publish.promotion_id).
      publishes.order(:site_id).includes(:site).
      each do |p|
        @sites.push(p.site) unless p.site.nil?
    end
    @sites = @sites.uniq
  end

  def update
    @order = Order.by_client(@client).adjusted.readonly(false).find(params[:id])
    @order.attributes = params[:order]
    @order.status_flag = params[:order][:status_flag]
    @order.publish_id = Publish.
      where("promotion_id = ?", params[:publish][:promotion_id]).
      where("site_id = ?", params[:publish][:site_id]).
      first.try(:id)

    respond_to do |format|
      if @order.save!
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to :action => "index" }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "edit" }
      end
    end
  end

  def delete
    @order = Order.by_client(@client).adjusted.find(params[:id])
  end

  def destroy
    @order = Order.by_client(@client).adjusted.find(params[:id])

    respond_to do |format|
      if @order.destroy
        flash[:notice] = t("flash.notice.deleted")
        format.html { redirect_to :action => :index }
      else
        flash[:error] = t("flash.error.delete_failed")
        format.html { redirect_to :action => :index }
      end
    end
  end

  # promotionに紐づかれたsiteのid,nameをjsonで返す
  def promotion_publishes_sites
    respond_to do |format|
      format.html
      format.json{ render :json => Promotion.publishes_sites_options_for_select(@client.id, params[:promotion_id])}
    end
  end

  def approve
    unless params[:check_ids].nil?
      Order.transaction do
        Order.by_client(@client).
        where(["orders.id IN (?)", params[:check_ids]]).
        readonly(false).
        each do |order|
          order.approve_update_daily!
          order.approve!
        end
      end
    end 
    redirect_to :action => :index
  end

  def reject
    unless params[:check_ids].nil?
      Order.transaction do
        Order.by_client(@client).
        where(["orders.id IN (?)", params[:check_ids]]).
        readonly(false).
        each do |order|
          order.reject_update_daily!
          order.reject!
        end
      end
    end

    redirect_to :action => :index
  end

  def defer
    unless params[:check_ids].nil?
      Order.transaction do
        Order.by_client(@client).
        where(["orders.id IN (?)", params[:check_ids]]).
        readonly(false).
        each do |order|
          order.defer_update_daily!
          order.defer!
        end
      end
    end

    redirect_to :action => :index
  end

  def upload
    @order = Order.new
  end

  def uploaded
    @orders, @error_orders = [], []

    begin
      ActiveRecord::Base.transaction do
        CSV.parse(params[:order][:file].read).each do |line|
          next if line.empty?

          id = line[0]
          if Client.find(id).admins.include? current_admin
            if line[1].class == String
              val = line[1].to_i
            else
              val = line[1]
            end
            order = Order.by_client(@client).readonly(false).find_by_id(id) || Order.new
            if val == 1
              order.approve_update_daily!
              order.approve!
            else if val == 2
              order.reject_update_daily!
              order.reject!
              else if val == 3
                order.defer_update_daily!
                order.defer!
                end
              end
            end
          else
            raise ActiveRecord::RecordNotFound
          end
          

          if order.valid?
            @orders << order 
          else
            @error_orders << order
          end
        end
      end

    rescue
      redirect_to :action => :upload
    end

  end

protected
  def find_client
     @client = Client.find(params[:client_id])
  end

  def csv_name
    "#{params[:controller]}_#{params[:client_id]}.csv"
  end
  def authority_required
    unless current_admin.super_user?
      @client = Client.find(params[:client_id])
      unless @client.admins.include? current_admin
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end