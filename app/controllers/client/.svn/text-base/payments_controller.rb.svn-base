class Client::PaymentsController < ApplicationController
  layout 'client'

  before_filter :authenticate_client!
  before_filter :find_client
  before_filter :approved?
  before_filter :client_consigned!

  def index
    group_param = ["year(dailies.created_on)","month(dailies.created_on)"]

    @search = @client.
      dailies.
      select("dailies.client_id").
      select("SUM(final_all_reward) sum_final_all_reward").
      select("year(dailies.created_on) year_created_on").
      select("month(dailies.created_on) month_created_on")
      if search_promotion?
        @search = @search.select("promotion_id")
      end
      @search = @search.joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted = 0 )').
      joins('LEFT JOIN sites ON ( dailies.site_id = sites.id AND sites.deleted = 0 )').
      joins('LEFT JOIN promotions ON ( dailies.promotion_id = promotions.id AND promotions.deleted = 0 )').
      joins('LEFT JOIN partners ON (dailies.partner_id = partners.id )').
      select("COUNT(DISTINCT partners.id) partners_count")
      @search = @search.where('dailies.client_id = ?', @client.id).
      group(group_param).
      search(params[:search])

    @payments = @search.page(params[:page]).per(params[:per])
    @promotions = @client.promotions
    @selected_promotions = []
    if search_promotion?
      promotions = Promotion.find params[:search][:id_in]
      promotions.each do |promotion|
        @selected_promotions << promotion.id
      end
    end
    
    respond_to do |format|
      format.html
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

  def search_promotion?
    promotion_flg = false
    unless params[:search].nil?
      unless params[:search][:id_in].nil?
        unless params[:search][:id_in].empty?
          promotion_flg = true
        end
      end
    end
    return promotion_flg
  end
  
  def client_consigned!
    if current_client.consigned 
      raise ActiveRecord::RecordNotFound
    end
  end
end