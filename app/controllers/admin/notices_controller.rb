class Admin::NoticesController < ApplicationController
  layout "admin"
  before_filter :authenticate_admin!

  def index
    #デフォルトソート設定
    if params[:search].nil?
      params[:search] = {:meta_sort => 'updated_at.desc'}
    else if params[:search][:meta_sort].nil?
        params[:search][:meta_sort]='updated_at.desc'
      end
    end
    @search = Notice.search(params[:search])  

    @notices = @search.page(params[:page]).per(params[:per])

    respond_to do |format|
      format.html
    end
  end

  def show
    @notice = Notice.find(params[:id])
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(params[:notice])

    respond_to do |format|
      if @notice.save
        flash[:notice] = t("flash.notice.created")
        format.html { redirect_to :action => :index }
      else
        flash[:error] = t("flash.error.create_failed")
        format.html { render :action => :new }
      end
    end
  end

  def edit
    @notice = Notice.find(params[:id])
  end

  def update
    @notice = Notice.find(params[:id])

    respond_to do |format|
      if @notice.update_attributes(params[:notice])
        flash[:notice] = t("flash.notice.updated")
        format.html { redirect_to :action => :index }
      else
        flash[:error] = t("flash.error.update_failed")
        format.html { render :action => :edit }
      end
    end
  end

  def delete
    @notice = Notice.find(params[:id])
  end

  def destroy
    @notice = Notice.find(params[:id])
    respond_to do |format|
      if @notice.destroy
          flash[:notice] = t("flash.notice.deleted")
          format.html { redirect_to :action => :index }
      else
          flash[:error] = t("flash.error.delete_failed")
          format.html { render :action => :delete }
      end
    end
  end
end