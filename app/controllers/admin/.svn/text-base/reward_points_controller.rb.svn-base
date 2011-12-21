class Admin::RewardPointsController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!  
  before_filter :find_client 
  before_filter :find_promotion

  def index
    @reward_points = @promotion.reward_points

    respond_to do |format|
      format.html
    end
  end

  def new
    @reward_point = @promotion.reward_points.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @reward_point = @promotion.reward_points.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def create
    @reward_point = @promotion.reward_points.new(params[:reward_point])

    respond_to do |format|
      if @reward_point.save
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to polymorphic_path([:admin, @client, @promotion, :reward_points]) }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @reward_point = @promotion.reward_points.find(params[:id])

    respond_to do |format|
      if @reward_point.update_attributes(params[:reward_point])
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to polymorphic_path([:admin, @client, @promotion, :reward_points]) }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "edit" }
      end
    end
  end

  def delete
    @promotion.reward_points.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to polymorphic_path([:admin, @client, @promotion, :reward_points]) }
    end
  end

private
  def find_client 
     @client = Client.find(params[:client_id])
  end

  def find_promotion
     @promotion = @client.promotions.find(params[:promotion_id])
  end
end