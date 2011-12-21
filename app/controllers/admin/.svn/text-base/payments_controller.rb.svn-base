class Admin::PaymentsController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!

  def index
    group_param = ["dailies.client_id",
                   "clients.login_id",
                   "clients.company_name",
                   "clients.manager_name"]

    group_param.push "dailies.created_on" if created_on?

    @search = Daily.
      select("dailies.client_id").
      select("clients.login_id").
      select("clients.company_name").
      select("clients.manager_name").
      select("SUM(final_all_reward) sum_final_all_reward")
      @search = @search.joins('INNER JOIN clients ON (dailies.client_id = clients.id AND clients.deleted = 0 )')
      @search = @search.joins('LEFT JOIN sites ON ( dailies.site_id = sites.id AND sites.deleted = 0 )')
      @search = @search.joins('LEFT JOIN promotions ON ( dailies.promotion_id = promotions.id AND promotions.deleted = 0 )')
      @search = @search.group(group_param).
      search(params[:search])

    @partners_count = Hash.new
    client_ids = []
    @search.each do |value|
      client_ids.push value.client_id
    end
    client_ids.uniq.each do |client_id|
      @partners_count.store client_id,Client.find(client_id).partners_count
    end
    @clients = Client.where('id IN (?) ', client_ids.uniq)
    @payments = @search.page(params[:page]).per(params[:per])

    respond_to do |format|
      format.html
    end
  end
  
  def created_on?
    created_on_flg = false
    unless params[:search].nil?
      unless params[:search][:created_on_eq].nil?
        unless params[:search][:created_on_eq].empty?
          created_on_flg = true
        end
      end
    end

    return created_on_flg
  end

end