# encoding: utf-8
class Admin::OneTagsController < ApplicationController
  layout 'admin'
  
  before_filter :authenticate_admin!
  before_filter :find_client 
  before_filter :find_promotion
  before_filter :declare_consigned_work!
  before_filter :authority_required

  def show
    @asps = @client.asps.joins(:publishes).where(["promotion_id = ?", params[:promotion_id]])
  end

  def edit
    @asps = @client.asps.includes(:publishes).left_join_publishes(params[:promotion_id])
  end

  def update
    @asps = @client.asps.includes(:publishes).left_join_publishes(params[:promotion_id])

    publishes, delete_publishes = [], []
    @asps.each do |asp|
      # ASPがpromotionに紐づかれてるか
      if publish = asp.associated_promotion?(params[:promotion_id].to_i)
        unless params.key? :asp_ids
          delete_publishes.push publish
        else
          # チェックボックスにチェックが入ってなければ削除対象
          unless params[:asp_ids].include? asp.id.to_s
            delete_publishes.push publish
          end
        end
        next
      # ASPがpromotionに紐づかれてなくて、チェックボックスにチェックが入っていれば新規作成
      else
        if params.key? :asp_ids
          logger.debug asp.id.to_s
          if params[:asp_ids].include? asp.id.to_s
            publish = Publish.new({
              :promotion_id => params[:promotion_id],
              :asp_id => asp.id
            })
          else
            next
          end
        else
          next
        end
      end
      publish.approve!
      publishes.push publish
    end

    respond_to do |format|
      if Publish.transaction{publishes.each(&:save); delete_publishes.each(&:delete)}
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to :action => "show" }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "edit" }
      end
    end
  end

protected
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