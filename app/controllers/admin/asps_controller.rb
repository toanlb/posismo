# encoding: utf-8
class Admin::AspsController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!
  before_filter :find_client
  before_filter :declare_consigned_work!
  before_filter :authority_required

  def index
    @search = @client.asps.search(params[:search])
    @asps = @search.page(params[:page]).per(params[:per])
  end

  def show
    @asp = @client.asps.find(params[:id])
  end

  def new
    @asp = Asp.new
  end

  def edit
    @asp = @client.asps.find(params[:id])
  end

  def create
    @asp = Asp.new(params[:asp])
    @asp[:client_id] = params[:client_id]
    
    respond_to do |format|
      if @asp.save
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to :action => "show", :id => @asp.id }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @asp = @client.asps.find(params[:id])
    @asp.attributes = params[:asp]
    
    respond_to do |format|
      if @asp.save
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to :action => "show", :id => @asp.id }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "edit" }
      end
    end
  end

  def delete
    @asp = @client.asps.find(params[:id])
  end

  def destroy
    @asp = @client.asps.find(params[:id])
    @asp.destroy

    respond_to do |format|
      if @client.save
        flash[:notice] = t("flash.notice.deleted")
        format.html { redirect_to :action => :index }
      else
        flash[:error] = t("flash.error.delete_failed")
        format.html { redirect_to :action => :index }
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