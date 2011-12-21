# encoding: utf-8
class Client::RewardsController < Admin::RewardsController
  layout "client"

  skip_before_filter :authenticate_admin!
  skip_before_filter :authority_required
  before_filter :authenticate_client!
  before_filter :find_client
  before_filter :find_promotion
  before_filter :client_consigned!

  def index
    redirect_to polymorphic_url([:admin, @client, @promotion], :anchor => "tabReward" )  
  end

  def create
    @reward = @promotion.rewards.new(params[:reward])
    @reward.reward_type = @promotion.basic_reward.blank? ? 
      Reward::TYPES.index("基本報酬") : Reward::TYPES.index("キャンペーン報酬")

    respond_to do |format|
      if @reward.save
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to polymorphic_url( [:client, @promotion], :anchor => "tabReward" ) }
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
        format.html { redirect_to polymorphic_url( [:client, @promotion], :anchor => "tabReward" ) }
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
        format.html { redirect_to polymorphic_url( [:client, @promotion], :anchor => "tabReward" ) }
      end
    else
      @reward.destroy
      respond_to do |format|
          format.html { redirect_to polymorphic_url( [:client, @promotion], :anchor => "tabReward" ) }
      end
    end
  end

private
  def find_client 
     @client = current_client
  end

  def find_promotion
    @promotion = @client.promotions.find(params[:promotion_id])
  end

  def basic_blank?
    params[:reward][:reward_type].last.blank? ? Reward::TYPES.index("キャンペーン報酬").to_s : params[:reward][:reward_type].last
  end
  
  def client_consigned!
    if current_client.consigned 
      raise ActiveRecord::RecordNotFound
    end
  end
  
end