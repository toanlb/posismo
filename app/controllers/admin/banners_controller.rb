class Admin::BannersController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_admin!
  before_filter :find_client
  before_filter :find_promotion
  before_filter :declare_consigned_work!
  before_filter :authority_required
  
  def new
    @banner = @promotion.banners.new
    @banner.type ||= 'ImageBanner'
  end

  def create
    case params[:banner][:type]
    when 'TextBanner'
      @banner = @promotion.text_banners.new(params[:banner])
    when 'ImageBanner'
      @banner = @promotion.image_banners.new(params[:banner])
    else
      @banner = @promotion.banners.new(params[:banner])
      @banner.type = params[:banner][:type]
      return render :action => :new
    end

    if @banner.save
      flash[:notice] = t("flash.notice.saved")
      redirect_to polymorphic_path([:admin, @client, @promotion], :anchor => "tabBanner")
    else
      flash[:error] = t("flash.error.save_failed")
      return render :action => :new
    end
  end
  
  def edit
    @banner = @promotion.banners.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  def update
    @banner = @promotion.banners.find(params[:id])

    respond_to do |format|
      if @banner.update_attributes(params[:banner])
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to polymorphic_url( [:admin, @client, @promotion], :anchor => "tabBanner" ) }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html {render :action => "new"}
      end
    end
  end
  
  # TODO: delete
  def image
    @banner = ImageBanner.new(params[:banner])
    @image_path = @banner.image.url
    render_to_string
  end
  
  def delete
    @promotion.banners.find(params[:id]).destroy

    respond_to do |format|
        format.html { redirect_to polymorphic_url( [:admin, @client, @promotion], :anchor => "tabBanner" ) }
    end
  end
  protected

  def find_client
    @client = Client.find(params[:client_id])
  end
  
  def find_promotion
    @promotion = Promotion.find(params[:promotion_id])
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
