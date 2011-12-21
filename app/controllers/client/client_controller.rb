class Client::ClientController < ApplicationController
  layout "client"

  before_filter :authenticate_client!
  before_filter :find_client
  before_filter :approved?

  def index
    @notices = Notice.for_client.order("updated_at DESC").limit(20)
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
      if @client.update_attributes(params[:client])
        format.html { redirect_to client_account_path }
      else
        format.html { render :action => "edit" }
      end
    end
  end

protected
  def approved?
     redirect_to client_account_thanks_path unless @client.approved?
  end

private
  def find_client
    @client = current_client
  end

end