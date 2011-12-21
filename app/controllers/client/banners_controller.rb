class Client::BannersController < Admin::BannersController
    layout "client"

  skip_before_filter :authenticate_admin!
  skip_before_filter :authority_required
  before_filter :authenticate_client!
  before_filter :find_client
  before_filter :find_promotion
  before_filter :client_consigned!
  
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
      redirect_to polymorphic_path([:client, @promotion], :anchor => "tabBanner")
    else
      flash[:error] = t("flash.error.save_failed")
      return render :action => :new
    end
  end
  
    def update
    @banner = @promotion.banners.find(params[:id])

    respond_to do |format|
      if @banner.update_attributes(params[:banner])
        flash[:notice] = t("flash.notice.saved")
          format.html { redirect_to polymorphic_url( [:client, @promotion], :anchor => "tabBanner" ) }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html {render :action => "new"}
      end
    end
  end
  
  def delete
    @promotion.banners.find(params[:id]).destroy

    respond_to do |format|
        format.html { redirect_to polymorphic_url( [:client, @promotion], :anchor => "tabBanner" ) }
    end
  end
private
  def find_client 
     @client = current_client
  end

  def find_promotion
    @promotion = @client.promotions.find(params[:promotion_id])
  end
  
  def client_consigned!
    if current_client.consigned 
      raise ActiveRecord::RecordNotFound
    end
  end
  
end