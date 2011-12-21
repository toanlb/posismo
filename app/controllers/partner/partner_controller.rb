# encoding: utf-8
class Partner::PartnerController < ApplicationController
  layout 'partner'

  before_filter :authenticate_partner!
  before_filter :find_partner
  before_filter :approved?

  def index
    @notices = Notice.for_partner.order("updated_at DESC").limit(20)
    
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      @partner.login_id = params[:partner][:login_id]
      @partner.email = params[:partner][:email]
      @partner.password = params[:partner][:password]
      @partner.password_confirmation = params[:partner][:password_confirmation]
      @partner.contract_type = params[:partner][:contract_type]
      @partner.company_name = params[:partner][:company_name]
      @partner.company_name_kana = params[:partner][:company_name_kana]
      @partner.contractor_department = params[:partner][:contractor_department]
      @partner.contractor_position = params[:partner][:contractor_position]
      @partner.contractor_name = params[:partner][:contractor_name]
      @partner.contractor_name_kana = params[:partner][:contractor_name_kana]
      @partner.manager_department = params[:partner][:manager_department]
      @partner.manager_position = params[:partner][:manager_position]
      @partner.manager_name = params[:partner][:manager_name]
      @partner.manager_name_kana = params[:partner][:manager_name_kana]
      @partner.postal_code = params[:partner][:postal_code]
      @partner.address = params[:partner][:address]
      @partner.tel = params[:partner][:tel]
      @partner.payment_type = params[:partner][:payment_type]
      @partner.bank_name = params[:partner][:bank_name]
      @partner.bank_code = params[:partner][:bank_code]
      @partner.branch_name = params[:partner][:branch_name]
      @partner.branch_code = params[:partner][:branch_code]
      @partner.account_type = params[:partner][:account_type]
      @partner.account_number = params[:partner][:account_number]
      @partner.account_name = params[:partner][:account_name]
      @partner.jpbank_account_number = params[:partner][:jpbank_account_number]
      @partner.jpbank_account_name = params[:partner][:jpbank_account_name]

      change_datas = @partner.changes
      if @partner.save
        @admins = find_admins_for_notification
        @admins.each do |admin|
          PartnerNotifier.notify_to_admin(admin, @partner, change_datas).deliver
        end
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to partner_account_path }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "edit" }
      end
    end
  end

  def delete
  end

  def destroy
    @partner.deleted = true

    respond_to do |format|
      if @partner.save
        flash[:notice] = t("flash.notice.deleted")
        format.html { redirect_to :action => :index }
      else
        flash[:error] = t("flash.error.delete_failed")
        format.html { redirect_to :action => :index }
      end
    end
  end

  def preresign
    respond_to do |format|
      format.html
    end
  end

  def resign
    begin
      find_partner
      if @partner.valid_password? params[:partner][:password]
        @partner.deleted = true
        if @partner.save
          PartnerNotifier.resign_notify(@partner).deliver
          flash[:notice] = t("flash.notice.partner_deleted")
          redirect_to root_path
        else
          flash[:error] = t("flash.error.delete_failed")
          redirect_to :action => :preresign
        end
      else
        flash[:error] = t("flash.error.delete_failed")
        redirect_to :action => :preresign
      end
    rescue
      flash[:error] = t("flash.error.mail_failed")
      redirect_to :action => :index
    end
  end

protected
  def approved?
     redirect_to partner_account_thanks_path unless @partner.approved?
  end
  
private
  def find_partner
    @partner = current_partner
  end

end
