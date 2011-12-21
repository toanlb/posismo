class Partner::RegistrationsController < Devise::RegistrationsController

  def new
    @partner = Partner.new

    @site = Site.new(params[:site]) || Site.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @partner = Partner.new
    @site = Site.new(params[:site])

    @partner.send(:attributes=, params[:partner], false)
    respond_to do |format|
      begin
        Partner.transaction do
          @partner.save!
          @site.partner_id = @partner.id
          @site.save!
        end
        @admins = find_admins_for_notification
        @admins.each do |admin|
          AdminNotifier.partner_registered(admin, @partner).deliver
        end
        flash[:notice] = t("flash.notice.partner_registered")
        format.html { redirect_to new_partner_session_path }
      rescue
        flash[:error] = t("flash.error.create_failed")
        format.html { render :action => "new" }
      end
    end
  end

end
