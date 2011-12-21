class Client::RewardPointsController < Admin::RewardPointsController
  layout 'client'

  skip_before_filter :authenticate_admin!
  before_filter :authenticate_client!
  before_filter :find_client
  before_filter :find_promotion

  def create
    @reward_point = @promotion.reward_points.new(params[:reward_point])

    respond_to do |format|
      if @reward_point.save
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to client_promotion_reward_points_path(@promotion) }
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
        format.html { redirect_to client_promotion_reward_points_path(@promotion) }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "edit" }
      end
    end
  end

  def delete
    @promotion.reward_points.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to client_promotion_reward_points_path(@promotion) }
    end
  end

private
  def find_client
    @client = current_client
  end

  def find_promotion
     @promotion = @client.promotions.find(params[:promotion_id])
  end
end