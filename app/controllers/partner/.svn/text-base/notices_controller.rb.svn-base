class Partner::NoticesController < ApplicationController
  layout 'partner'
  before_filter :authenticate_partner!

  def index
    #デフォルトソート設定
    if params[:search].nil?
      params[:search] = {:meta_sort => 'updated_at.desc'}
    else if params[:search][:meta_sort].nil?
        params[:search][:meta_sort]='updated_at.desc'
      end
    end
    @search = Notice.for_partner.search(params[:search])  

    @notices = @search.page(params[:page]).per(params[:per])

    respond_to do |format|
      format.html
    end
  end

  def show
    @notice = Notice.for_partner.find(params[:id])
  end
end