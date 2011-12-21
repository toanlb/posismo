class Admin::AccountManagementsController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin!
  before_filter :find_client, :only => [:edit, :update]
  before_filter :authority_required, :only => [:edit, :update]
  
  def new
    @admins = Admin.where(:super_user => false).where("id <> ?",current_admin.id).order('login_id')
    @clients = current_admin.super_user? ? Client.all : current_admin.clients
  end
  
  def create
    if params[:account_management].nil?
      params[:account_management] = {:admin_ids => [], :client_ids => []}
    end
    @clients = Client.find params[:account_management][:client_ids]
    account_managements, delete_account_managements = [],[]
    @clients.each do |client|
      @account_managements = client.account_managements
      admin_ids = []
      if params[:account_management][:admin_ids].nil?
        @account_managements.each do |account_management|
          unless account_management.admin_id == current_admin.id
            delete_account_managements << account_management
          end
        end
      else
        @account_managements.each do |account_management|
        unless params[:account_management][:admin_ids].include? account_management.admin_id
          unless account_management.admin_id == current_admin.id
            delete_account_managements << account_management
          end
        end
        admin_ids << account_management.admin_id
        end
        params[:account_management][:admin_ids].each do |admin_id|
          unless admin_ids.include? admin_id
            new_account_management = client.account_managements.new
            new_account_management.admin_id = admin_id
            account_managements << new_account_management 
          end
        end
      end
    end
    respond_to do |format|
      if AccountManagement.transaction{account_managements.each(&:save); delete_account_managements.each(&:delete)}
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to admin_clients_path }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "new" }
      end
    end
  end
  
  def edit
    @admins = Admin.where(:super_user => false).where("id <> ?",current_admin.id).order('login_id')
    @select_admins = []
    @client.account_managements.each do |account_management|
      @select_admins << account_management.admin_id
    end
  end

  def update
    if params[:account_management].nil?
      params[:account_management] = {:admin_ids => []}
    end
    account_managements, delete_account_managements = [],[]
    @account_managements = @client.account_managements
    admin_ids = []
    @account_managements.each do |account_management|
      unless params[:account_management][:admin_ids].include? account_management.admin_id 
        unless account_management.admin_id == current_admin.id
          delete_account_managements << account_management
        end
      end
      admin_ids << account_management.admin_id
    end
    params[:account_management][:admin_ids].each do |admin_id|
      unless admin_ids.include? admin_id
        new_account_management = @client.account_managements.new
        new_account_management.admin_id = admin_id
        account_managements << new_account_management 
      end
    end
    respond_to do |format|
      if AccountManagement.transaction{account_managements.each(&:save); delete_account_managements.each(&:delete)}
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to polymorphic_path([:admin, @client]) }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "edit" }
      end
    end
  end
  
  private
  def find_client
    @client = Client.find(params[:client_id])
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
