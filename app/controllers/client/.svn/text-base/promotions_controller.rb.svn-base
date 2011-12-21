# -*- coding: utf-8 -*-
require 'csv'
class Client::PromotionsController < Admin::PromotionsController
  layout "client"

  skip_before_filter :authenticate_admin!
  skip_before_filter :authority_required
  before_filter :authenticate_client!, :except => :child_categories
  before_filter :find_client, :except => :child_categories
  before_filter :client_consigned!
  
  def create
    @promotion = @client.promotions.new(params[:promotion])
    respond_to do |format|
      begin
        @promotion.save

        @categories_promotions = []
        params[:categories_promotions].each do |key, categories_promotion|
          category_id = categories_promotion[:category_id].blank? ? categories_promotion[:parent_category_id] : categories_promotion[:category_id]
          next if category_id.blank?

          new = CategoriesPromotion.new({:category_id => category_id})
          new.promotion_id = @promotion.id
          @categories_promotions << new
        end
        CategoriesPromotion.transaction{@categories_promotions.each(&:save)}

        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to polymorphic_url( [:client, @promotion] ) }
      rescue
        flash[:error] = t("flash.error.save_failed")
        @parent_options = Category.parent_category_options_for_select
        format.html { render :action => "new" }
      end
    end
  end
  
  def csv
    @promotions = @client.promotions.search(params[:search])
    header = %w(プロモーション名 URL グロス価格 グロスレート 開始日 カテゴリー)
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << header.map{|head| head.encode("CP932")}
          @promotions.each do |promotion|
            tmp_csv = Array.new(6)
            rewards = []
            click_rewards = []
            categories_promotions = []
            tmp_csv[0] = promotion.name
            tmp_csv[1] = promotion.url

            promotion.rewards.each do |reward|
              rew = Reward.basic_reward(reward)
              rew.each do |r|
                tmp_csv[2] = r.gross_price
                tmp_csv[3] = r.gross_rate
                tmp_csv[4] = r.starts_at
              end
            end
            promotion.categories_promotions.each do |category|
              tmp_csv[5] = category.category.category_name
            end

            csv << tmp_csv
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => self.csv_name)
      end
    end
  end

  def update
    @promotion = @client.promotions.find(params[:id])
    @promotion.attributes = params[:promotion]
    respond_to do |format|
      begin
        @promotion.active? ? @promotion.activate! : @promotion.deactivate!
        @categories_promotions = @promotion.categories_promotions.order(:id)

        CategoriesPromotion.transaction do
          params[:categories_promotions].each do |key, param_categories_promotion|
            categories_promotion = @categories_promotions[key.to_i]
            if param_categories_promotion[:category_id].blank? && param_categories_promotion[:parent_category_id].blank?
              categories_promotion.try(:delete) 
              next
            end

            category_id = param_categories_promotion[:category_id].blank? ? param_categories_promotion[:parent_category_id] : param_categories_promotion[:category_id]

            if categories_promotion.nil?
              categories_promotion = CategoriesPromotion.new({:category_id => category_id})
              categories_promotion.promotion_id = @promotion.id
            else
              categories_promotion.category_id = category_id
            end
            categories_promotion.save
          end

        end
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to polymorphic_url( [:client, @promotion] ) }
      rescue
        @parent_options = Category.parent_category_options_for_select
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "edit" }
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
  
  def client_consigned!
    if current_client.consigned 
      raise ActiveRecord::RecordNotFound
    end
  end
  
end
