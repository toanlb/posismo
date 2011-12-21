class Client::NoticesController < ApplicationController
  layout "client"
  before_filter :authenticate_client!

  def index
    #デフォルトソート設定
    if params[:search].nil?
      params[:search] = {:meta_sort => 'updated_at.desc'}
    else if params[:search][:meta_sort].nil?
        params[:search][:meta_sort]='updated_at.desc'
      end
    end
    @search = Notice.for_client.search(params[:search])

    @notices = @search.page(params[:page]).per(params[:per])

    respond_to do |format|
      format.html
    end
  end

  def show
    @notice = Notice.for_client.find(params[:id])
  end
end