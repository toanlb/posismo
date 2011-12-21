class Admin::ClientMonthliesController < ApplicationController
  layout "admin"
  before_filter :authenticate_admin!
  before_filter :super_admin?

  def index
    @search = ClientMonthly::search(params[:search])
    @monthlies = @search.page(params[:page]).per(params[:per])
  end

protected
  def super_admin?
    raise ActiveRecord::RecordNotFound unless current_admin.super_user?
  end
end
