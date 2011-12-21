# -*- coding: utf-8 -*-
require 'csv'

class Admin::PromotionsController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!, :except => :child_categories
  before_filter :find_client, :except => :child_categories
  before_filter :declare_consigned_work!
  before_filter :authority_required

  def index
    @search = @client.promotions.search(params[:search])
    @promotions = @search.page(params[:page]).per(params[:per])
    @promotions_for_select = @client.promotions
    @selected_promotions = []

    if search_promotion?
      promotions = Promotion.find params[:search][:id_in]
      promotions.each do |promotion|
        @selected_promotions << promotion.id
      end
    end

    respond_to do |format|
      format.html
    end
  end

  def csv
    @promotions = @client.promotions.search(params[:search])
    header = %w(プロモーション名 URL グロス価格 ネット価格 グロスレート ネットレート 開始日 カテゴリー)
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << header.map{|head| head.encode("CP932")}
          @promotions.each do |promotion|
            tmp_csv = Array.new(8)
            rewards = []
            click_rewards = []
            categories_promotions = []
            tmp_csv[0] = promotion.name
            tmp_csv[1] = promotion.url

            promotion.rewards.each do |reward|
              rew = Reward.basic_reward(reward)
              rew.each do |r|
                tmp_csv[2] = r.gross_price
                tmp_csv[3] = r.net_price
                tmp_csv[4] = r.gross_rate
                tmp_csv[5] = r.net_rate
                tmp_csv[6] = r.starts_at
              end
            end
            promotion.categories_promotions.each do |category|
              tmp_csv[7] = category.category.category_name
            end

            csv << tmp_csv
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => self.csv_name)
      end
    end
  end

  def show
    @promotion = @client.promotions.find(params[:id])
    @categories = @promotion.categories_promotions.includes([:category]).order(:id).limit(CategoriesPromotion::LIMIT_PER_PROMOTION)

    @search_rewards = @promotion.rewards.search(params[:search])
    @search_banners = @promotion.banners.search(params[:search])
    @search_asps = @promotion.asps.where(["promotion_id = ?", params[:id]]).search(params[:search])

    @click_reward = ClickReward.new
    @category = Category.new

    respond_to do |format|
      format.html
    end
  end

  def new
    @promotion = @client.promotions.new
    @promotion.click_reward = ClickReward.new
    @parent_options = Category.parent_category_options_for_select

    respond_to do |format|
      format.html
    end
  end

  def edit
    @promotion = @client.promotions.find(params[:id])
    @categories_promotions = @promotion.categories_promotions
    @parent_options = Category.parent_category_options_for_select
    @child_options = []
    @categories_promotions.each do |category_promotion|
      @child_options << Category.child_category_options_for_select(category_promotion.category.parent_id || category_promotion.category_id)
    end

    respond_to do |format|
      format.html
    end
  end

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
          format.html { redirect_to polymorphic_url( [:admin, @client, @promotion] ) }
      rescue
        flash[:error] = t("flash.error.save_failed")
        @parent_options = Category.parent_category_options_for_select
        format.html { render :action => "new" }
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
        format.html { redirect_to polymorphic_url( [:admin, @client, @promotion] ) }
      rescue
        @parent_options = Category.parent_category_options_for_select
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "edit" }
      end
    end
  end

  def delete
    @promotion = @client.promotions.find(params[:id])
  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        @promotion = @client.promotions.find(params[:id])
        if @promotion.publishes.empty?
          @promotion.deleted = true
          @promotion.check_related_publishes
          @promotion.save!
        else
          publishe_ids = []
          @promotion.publishes.each do |data|
            publishe_ids = publishe_ids.push data
          end
          raise 'Publish Update Error' unless Publish.update_all ['deleted = ? ', "true"], ['id IN (?)', publishe_ids]
          @promotion.deleted = true
          @promotion.check_related_publishes
          @promotion.save!
        end
          AdminNotifier.notify_promotion_to_partner(@promotion, @client.partners).deliver
      rescue
        respond_to do |format|
          flash[:notice] = t("flash.error.delete_failed")
          format.html { redirect_to :action => :index }
        end
      else
        respond_to do |format|
          flash[:notice] = t("flash.notice.deleted")
          format.html { redirect_to :action => :index }
        end
      end
    end
  end

  def toggle_active
    @promotion = @client.promotions.find(params[:id])

    respond_to do |format|
      if @promotion.toggle_activate!
        flash[:notice] = t(@promotion.active? ? "flash.notice.activated" : "flash.notice.deactivated")
        format.html { redirect_to :action => :show }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { redirect_to :action => :show }
      end
    end

  end

  def conversion_tag
    @promotion = @client.promotions.find(params[:id])
  end

  # 子カテゴリのid,nameをJSON形式で返す
  def child_categories
    respond_to do |format|
      format.html
      format.json{ render :json => Category.child_category_options_for_select(params[:parent_id])}
    end
  end

  def upload
    @promotion = @client.promotions.new
  end

  def uploaded
    @promotions, @error_promotions = [], []
    
    begin
      Promotion.transaction do
        CSV.parse(params[:promotion][:file].read).each do |line|
          next if line.empty?
  
          id = line[0]
          promotion = @client.promotions.find_by_id(id) || @client.promotions.new
          promotion.attributes = {:name => line[1], :url => line[2]}
          promotion.save! if promotion.valid?
  
          if promotion.valid?
            @promotions << promotion 
          else
            @error_promotions << promotion
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

  def search_promotion?
    promotion_flg = false
    unless params[:search].nil?
      unless params[:search][:id_in].nil?
        unless params[:search][:id_in].empty?
          promotion_flg = true
        end
      end
    end
    return promotion_flg
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
