# -*- coding: utf-8 -*-
require 'csv'

class Partner::PromotionsController < ApplicationController

  layout 'partner'
  
  before_filter :authenticate_partner!
  before_filter :find_partner

  def index
    @search = Promotion.activated.search(params[:search])
    @promotions = @search.page(params[:page]).per(params[:per])

    respond_to do |format|
      format.html
    end
  end

  def csv
    @search = Promotion.activated.search(params[:search])

    header = %w(プロモーション名 遷移先URL プロモーション詳細 クリック報酬 会社名)
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << header.map{|head| head.encode("CP932")}
          @search.each do |row|
            #移行したデータにクリック報酬はnilの場合がありますので、この判断を追加します。
            if row.click_reward.nil?
              csv << [ row.name, row.url, row.description, 0, row.client.company_name ]
            else
              csv << [ row.name, row.url, row.description, row.click_reward.price, row.client.company_name ]
            end
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => "promotions.csv")
      end
    end
  end

  def affiliate

    @promotion = Promotion.activated.find(params[:id])
    # TODO Fix below! merge queries into one.
    @sites = @partner.sites - @promotion.sites
    @publish = @promotion.publishes.new(params[:publish])
    if request.post?
      respond_to do |format|
        if @publish.site && @publish.save
          flash[:notice] = t("flash.notice.affiliate_applied")
          format.html { redirect_to :action => :index }
        else
          flash[:error] = t("flash.error.affiliate_apply_failed")
          format.html { redirect_to :action => :index }
        end
      end
    else
    end
  end

  def show
    @promotion = Promotion.find(params[:id])
    @categories = @promotion.categories_promotions.includes([:category]).order(:id).limit(CategoriesPromotion::LIMIT_PER_PROMOTION)

    @search_rewards = @promotion.rewards.where('starts_at <= ? ',Time.now).where('ends_at >= ? OR ends_at IS NULL',Time.now).search(params[:search])
    @search_banners = @promotion.banners.search(params[:search])
   
  end

protected
  def find_partner
     @partner = current_partner
  end

  def csv_name
    "#{params[:controller]}.csv"
  end
end