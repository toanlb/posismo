class Admin::AdminController < ApplicationController
  layout "admin"
  before_filter :authenticate_admin!
  
  def index
  end

  def show
    @admin = current_admin

    respond_to do |format|
      format.html
    end
  end

  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin
    
    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        ## TODO: Flash Notice Required!!
        format.html { redirect_to :action => :show }
      else
        format.html { render :action => :edit }
      end
    end
  end

  def manage
    # TODO
  end

  def bills
    # TODO
  end

  def notifications
    # TODO
  end
end
