class Admin::AdminsController < ApplicationController
  layout "admin"

  before_filter :authenticate_admin!
  before_filter :super_admin_required!

  def index
    @search = Admin.including_deleted.search(params[:search])
    @admins = @search.page(params[:page]).per(params[:per])

    respond_to do |format|
      format.html
    end
  end

  def show
      @admin = Admin.including_deleted.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @admin = Admin.new
    
    respond_to do |format|
      format.html
    end
  end

  def create
        @admin = Admin.create(params[:admin])
        @admin.super_user = params[:admin][:super_user] || false
        respond_to do |format|
            if @admin.save
          flash[:notice] = t("flash.notice.created")
        format.html { redirect_to :action => :show, :id => @admin }
      else
        flash[:error] = t("flash.error.create_failed")
        format.html { render :action => :new }
      end
        end
  end

  def edit
      @admin = Admin.including_deleted.find(params[:id])
  end

  def update
    @admin = Admin.including_deleted.find(params[:id])
    @admin.super_user = params[:admin][:super_user] || false
    @admin.send(:attributes=, params[:admin], false)

    respond_to do |format|
          if @admin.save
          flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to :action => :show }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => :edit }
      end
    end
  end

  def delete
      @admin = Admin.find(params[:id])
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.deleted = true

    respond_to do |format|
      if @admin.save
          flash[:notice] = t("flash.notice.deleted")
        format.html { redirect_to :action => :index }
      else
          flash[:error] = t("flash.error.delete_failed")
        format.html { redirect_to :action => :index }
      end
    end
  end

protected

private
  def super_admin_required!
      unless current_admin.super_user?
        raise ActiveRecord::RecordNotFound
      end
  end

end