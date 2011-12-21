# -*- coding: utf-8 -*-
require 'csv'

class Partner::PublishesController < ApplicationController
  layout 'partner'

  before_filter :authenticate_partner!
  before_filter :find_partner

  def index
    if params[:search].nil?
      params[:search] = {:approval_status_eq => 1}
    elsif params[:search][:approval_status_eq].nil?
      params[:search][:approval_status_eq] = 1
    end
    
    promotion_ids = []
    site_ids = []
    @partner.publishes.each do |publish|
      promotion_ids << publish.promotion_id
      site_ids << publish.site_id
    end
    
    @promotions = Promotion.find promotion_ids
    @sites = Site.find site_ids
    @search = @partner.publishes.where("approval_status in (0,1)").search(params[:search])
    @publishes = @search.page(params[:page]).per(params[:per])
    @selected_promotions = params[:search][:promotion_id_in]
    @selected_sites = params[:search][:site_id_in]
    respond_to do |format|
      format.html
    end
  end
  
  def csv
    @search = @partner.publishes.search(params[:search])

    header = %w(プロモーション名 サイト名 承認状態)
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << header.map{|head| head.encode("CP932")}
          @search.each do |row|
            csv << [ row.promotion.name, row.site.name, row.approval_status ]
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => "publishes.csv")
      end
    end
  end

  def show
    @publish = @partner.publishes.find(params[:id])
    @promotion = @publish.promotion
    @site = @publish.site
    @banners_search = @publish.promotion.banners.search(params[:search])
    @banners = @banners_search.page(params[:page]).per(params[:per])
  end

  def delete
    @publish = @partner.publishes.find(params[:id])
    @promotion = @publish.promotion
    @site = @publish.site
  end

  def destroy
    @publish = @partner.publishes.readonly(false).find(params[:id])
    @publish.deleted = true

    respond_to do |format|
      if @publish.save
        flash[:notice] = t("flash.notice.deleted")
        format.html { redirect_to :action => :index }
      else
        flash[:error] = t("flash.error.delete_failed")
        format.html { redirect_to :action => :index }
      end
    end
  end

protected
  def find_partner
     @partner = current_partner
  end

  def csv_name
    "#{params[:controller]}.csv"
  end
end
