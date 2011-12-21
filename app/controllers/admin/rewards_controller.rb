# encoding: utf-8
class Admin::RewardsController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!
  before_filter :find_client 
  before_filter :find_promotion
  before_filter :declare_consigned_work!
  before_filter :authority_required
  
  def index
    redirect_to polymorphic_url([:admin, @client, @promotion], :anchor => "tabReward" )
  end

  def new
    @reward = @promotion.rewards.new(params[:reward])
    @reward.reward_type = @promotion.basic_reward.blank? ? 
      Reward::TYPES.index("基本報酬") : Reward::TYPES.index("キャンペーン報酬")
    @reward.starts_at = @reward.starts_at || DateTime.current
    respond_to do |format|
      format.html
    end
  end

  def edit
    @reward = @promotion.rewards.find(params[:id])
    @reward.starts_at = @reward.starts_at.strftime("%Y-%m-%d %H:%M")
    @reward.ends_at = @reward.ends_at.nil? ? nil : @reward.ends_at.strftime("%Y-%m-%d %H:%M")
    respond_to do |format|
      format.html
    end
  end

  def create
    @reward = @promotion.rewards.new(params[:reward])
    @reward.reward_type = @promotion.basic_reward.blank? ? 
      Reward::TYPES.index("基本報酬") : Reward::TYPES.index("キャンペーン報酬")

    respond_to do |format|
      if @reward.save
        flash[:notice] = t("flash.notice.saved")
          format.html { redirect_to polymorphic_url( [:admin, @client, @promotion], :anchor => "tabReward" ) }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html {render :action => "new"}
      end
    end
  end

  def update
    @reward = @promotion.rewards.find(params[:id])

    respond_to do |format|
      if @reward.update_attributes(params[:reward])
        flash[:notice] = t("flash.notice.saved")
          format.html { redirect_to polymorphic_url( [:admin, @client, @promotion], :anchor => "tabReward" ) }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html {render :action => "new"}
      end
    end
  end

  def delete
    @reward = @promotion.rewards.find(params[:id])
    if @promotion.active? && @reward.reward_type == 0
      respond_to do |format|
        flash[:notice] = t("flash.error.reward_delete_failed")
        format.html { redirect_to polymorphic_url( [:admin, @client, @promotion], :anchor => "tabReward" ) }
      end
    else
      @reward.destroy
      respond_to do |format|
          format.html { redirect_to polymorphic_url( [:admin, @client, @promotion], :anchor => "tabReward" ) }
      end
    end
  end

private
  def find_client 
     @client = Client.find(params[:client_id])
  end

  def find_promotion
     @promotion = @client.promotions.find(params[:promotion_id])
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
