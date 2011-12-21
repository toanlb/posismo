# encoding: utf-8
require 'csv'
class Admin::StatisticsController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!  
  before_filter :find_client 
  before_filter :declare_consigned_work!
  before_filter :authority_required

  def index
    group_param = ["dailies.client_id", "dailies.created_on"]

    group_param.push "dailies.promotion_id" if search_promotion?
    group_param.push "dailies.site_id" if search_id?
    
    #デフォルトソート設定
    if params[:search].nil?
      params[:search] = {:meta_sort => 'created_on.desc'}
    else if params[:search][:meta_sort].nil?
        params[:search][:meta_sort]='created_on.desc'
      end
    end
    
    @sum_statistic = @client.
      statistics.
      select("SUM(impression_count) sum_impression_count").
      select("SUM(click_count) sum_click_count").
      select("SUM(click_valid_count) sum_click_valid_count").
      select("COALESCE((SUM(click_count)/SUM(impression_count)),0) sum_click_rate").
      select("SUM(final_click_reward) sum_final_click_reward").
      select("COALESCE((SUM(plan_order_count)/SUM(click_count)),0) sum_conversion_rate").
      select("SUM(plan_order_count) sum_plan_order_count").
      select("SUM(final_order_count) sum_final_order_count").
      select("SUM(cancel_order_count) sum_cancel_order_count").
      select("SUM(plan_order_reward) sum_plan_order_reward").
      select("SUM(plan_order_net_reward) sum_plan_order_net_reward").
      select("SUM(final_order_reward) sum_final_order_reward").
      select("SUM(final_order_net_reward) sum_final_order_net_reward").
      select("SUM(final_all_reward) sum_final_all_reward").
      select("SUM(final_all_net_reward) sum_final_all_net_reward").
      select("dailies.created_on").
      joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted = 0 )').
      joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted = 0 )')

    @search = @sum_statistic.group(group_param).search(params[:search])
    @sum_statistic = @sum_statistic.search(params[:search])
      
    @statistics = @search.page(params[:page]).per(params[:per])
    @promotions = @client.promotions
    @sites = find_site
    @selected_promotions = []
    @display_promotions = []
    @selected_sites = []
    @display_sites = []
    @radio_daily = "week"

    if search_promotion?
      promotions = Promotion.find params[:search][:promotion_id_in]
      promotions.each do |promotion|
        @selected_promotions << promotion.id
        @display_promotions << promotion.name
      end
    end

    if search_id?
      sites = Site.find params[:search][:site_id_in]
      sites.each do |site|
        @selected_sites << site.id
        @display_sites << site.name
      end
    end
    if @search.all.blank?
      flash[:notice] = t("flash.notice.no_data")
    end
    
    respond_to do |format|
      format.html
    end
  end

  def csv
    #デフォルトソート設定
    if params[:search].nil?
      params[:search] = {:meta_sort => 'created_on.desc'}
    else
      if params[:search][:meta_sort].nil?
        params[:search][:meta_sort]='created_on.desc'
      else
        unless search_attributes?
          params[:search][:meta_sort]='created_on.desc'
        end
      end
    end
    
    group_param = ["dailies.created_on"]
    
    unless params[:search][:promotion_id_in].nil?
      unless params[:search][:promotion_id_in].empty?
        promotion_flg = true
        group_param.push "dailies.promotion_id"
      end
    end
    
    unless params[:search][:site_id_in].nil?
      unless params[:search][:site_id_in].empty?
        site_flg = true
        group_param.push "dailies.site_id"
      end
    end

    @sum_statistic = @client.
      statistics.
      select("SUM(impression_count) sum_impression_count").
      select("SUM(click_count) sum_click_count").
      select("SUM(click_valid_count) sum_click_valid_count").
      select("COALESCE((SUM(click_count)/SUM(impression_count)),0) sum_click_rate").
      select("SUM(final_click_reward) sum_final_click_reward").
      select("COALESCE((SUM(plan_order_count)/SUM(click_count)),0) sum_conversion_rate").
      select("SUM(plan_order_count) sum_plan_order_count").
      select("SUM(final_order_count) sum_final_order_count").
      select("SUM(cancel_order_count) sum_cancel_order_count").
      select("SUM(plan_order_reward) sum_plan_order_reward").
      select("SUM(plan_order_net_reward) sum_plan_order_net_reward").
      select("SUM(final_order_reward) sum_final_order_reward").
      select("SUM(final_order_net_reward) sum_final_order_net_reward").
      select("SUM(final_all_reward) sum_final_all_reward").
      select("SUM(final_all_net_reward) sum_final_all_net_reward").
      select("dailies.created_on").
      joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted = 0 )').
      joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted = 0 )')
    @search = @sum_statistic.group(group_param).search(params[:search])
    @sum_statistic = @sum_statistic.search(params[:search])
      @radio_daily = "week"
      
    if params[:search][:created_on_lt].blank?
      date = @search.first.created_on
    else
      date = Date.parse(params[:search][:created_on_lt])
    end
    
    unless params[:search][:created_on_gt].blank?
      end_date = Date.parse(params[:search][:created_on_gt])
    end
    count = 0
    
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << Statistic.admin_header_to_sjis
          @search.each do |row|
            unless search_attributes?
              while date > row.created_on
                csv << [date,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
                date = date - 1
                count = count + 1
              end
              date = date - 1
              count = count + 1
            end
            csv << [row.created_on,
                    row.sum_impression_count,
                    row.sum_click_count,
                    row.sum_click_valid_count,
                    row.sum_click_rate,
                    row.sum_final_click_reward,
                    row.sum_conversion_rate,
                    row.sum_plan_order_count,
                    row.sum_final_order_count,
                    row.sum_cancel_order_count,
                    row.sum_plan_order_reward,
                    row.sum_plan_order_net_reward,
                    row.sum_final_order_reward,
                    row.sum_final_order_net_reward,
                    row.sum_final_all_reward,
                    row.sum_final_all_net_reward
                    ]
          end
          unless search_attributes?
            unless params[:search][:created_on_gt].blank?
              while date >= end_date
                csv << [date,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
                date = date - 1
                count = count + 1
              end
            end
          end
          @sum_statistic.each do |row|
            csv << ["総計",
                    row.sum_impression_count,
                    row.sum_click_count,
                    row.sum_click_valid_count,
                    row.sum_click_rate,
                    row.sum_final_click_reward,
                    row.sum_conversion_rate,
                    row.sum_plan_order_count,
                    row.sum_final_order_count,
                    row.sum_cancel_order_count,
                    row.sum_plan_order_reward,
                    row.sum_plan_order_net_reward,
                    row.sum_final_order_reward,
                    row.sum_final_order_net_reward,
                    row.sum_final_all_reward,
                    row.sum_final_all_net_reward
                    ]
            csv << ["総平均",
                    row.sum_impression_count.nil? ? 0 : (row.sum_impression_count / count).round(2),
                    row.sum_click_count.nil? ? 0 : (row.sum_click_count / count).round(2),
                    row.sum_click_valid_count.nil? ? 0 : (row.sum_click_valid_count / count).round(2),
                    row.sum_click_rate,
                    row.sum_final_click_reward.nil? ? 0 : (row.sum_final_click_reward / count).round(2),
                    row.sum_conversion_rate,
                    row.sum_plan_order_count.nil? ? 0 : (row.sum_plan_order_count / count).round(2),
                    row.sum_final_order_count.nil? ? 0 : (row.sum_final_order_count / count).round(2),
                    row.sum_cancel_order_count.nil? ? 0 : (row.sum_cancel_order_count / count).round(2),
                    row.sum_plan_order_reward.nil? ? 0 : (row.sum_plan_order_reward / count).round(2),
                    row.sum_plan_order_net_reward.nil? ? 0 : (row.sum_plan_order_net_reward / count).round(2),
                    row.sum_final_order_reward.nil? ? 0 : (row.sum_final_order_reward / count).round(2),
                    row.sum_final_order_net_reward.nil? ? 0 : (row.sum_final_order_net_reward / count).round(2),
                    row.sum_final_all_reward.nil? ? 0 : (row.sum_final_all_reward / count).round(2),
                    row.sum_final_all_net_reward.nil? ? 0 : (row.sum_final_all_net_reward / count).round(2)
                    ]
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => self.csv_name)
      end
    end
  end

  def index_month
    #デフォルトソート設定
    if params[:search].nil?
      params[:search] = {:meta_sort => 'created_on.desc'}
    else if params[:search][:meta_sort].nil?
        params[:search][:meta_sort]='created_on.desc'
      end
    end
    
    group_param = ["dailies.client_id", "year(dailies.created_on)", "month(dailies.created_on)"]

    group_param.push "dailies.promotion_id" if search_promotion?
    group_param.push "dailies.site_id" if search_id?
    @sum_statistic = @client.
      statistics.
      select("SUM(impression_count) sum_impression_count").
      select("SUM(click_count) sum_click_count").
      select("SUM(click_valid_count) sum_click_valid_count").
      select("COALESCE((SUM(click_count)/SUM(impression_count)),0) sum_click_rate").
      select("SUM(final_click_reward) sum_final_click_reward").
      select("COALESCE((SUM(plan_order_count)/SUM(click_count)),0) sum_conversion_rate").
      select("SUM(plan_order_count) sum_plan_order_count").
      select("SUM(final_order_count) sum_final_order_count").
      select("SUM(cancel_order_count) sum_cancel_order_count").
      select("SUM(plan_order_reward) sum_plan_order_reward").
      select("SUM(plan_order_net_reward) sum_plan_order_net_reward").
      select("SUM(final_order_reward) sum_final_order_reward").
      select("SUM(final_order_net_reward) sum_final_order_net_reward").
      select("SUM(final_all_reward) sum_final_all_reward").
      select("SUM(final_all_net_reward) sum_final_all_net_reward").
      select("year(dailies.created_on) year_created_on").
      select("month(dailies.created_on) month_created_on").
      joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted = 0 )').
      joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted = 0 )')
      
    @search = @sum_statistic.group(group_param).search(params[:search])
    @sum_statistic = @sum_statistic.search(params[:search])
    @statistics = @search.page(params[:page]).per(params[:per])
    logger.debug @statistics
    @promotions = @client.promotions
    @sites = find_site
    @selected_promotions = []
    @display_promotions = []
    @selected_sites = []
    @display_sites = []
    @radio_daily = "month"

    if search_promotion?
      promotions = Promotion.find params[:search][:promotion_id_in]
      promotions.each do |promotion|
        @selected_promotions << promotion.id
        @display_promotions << promotion.name
      end
    end

    if search_id?
      sites = Site.find params[:search][:site_id_in]
      sites.each do |site|
        @selected_sites << site.id
        @display_sites << site.name
      end
    end
    
    if @search.all.blank?
      flash[:notice] = t("flash.notice.no_data")
    end
    
    respond_to do |format|
      format.html {render :action => 'index'}
    end
  end
  
  def csvmonth
    #デフォルトソート設定
    if params[:search].nil?
      params[:search] = {:meta_sort => 'created_on.desc'}
    else
      if params[:search][:meta_sort].nil?
        params[:search][:meta_sort]='created_on.desc'
      else
        unless search_attributes?
          params[:search][:meta_sort]='created_on.desc'
        end
      end
    end
    
    group_param = ["dailies.client_id", "year(dailies.created_on)", "month(dailies.created_on)"]
    unless params[:search].nil?
      unless params[:search][:promotion_id_in].nil?
        unless params[:search][:promotion_id_in].empty?
          promotion_flg = true
          group_param.push "dailies.promotion_id"
        end
      end
    end
    unless params[:search].nil?
      unless params[:search][:site_id_in].nil?
        unless params[:search][:site_id_in].empty?
          site_flg = true
          group_param.push "dailies.site_id"
        end
      end
    end
      
      @sum_statistic = @client.
      statistics.
      select("SUM(impression_count) sum_impression_count").
      select("SUM(click_count) sum_click_count").
      select("SUM(click_valid_count) sum_click_valid_count").
      select("COALESCE((SUM(click_count)/SUM(impression_count)),0) sum_click_rate").
      select("SUM(final_click_reward) sum_final_click_reward").
      select("COALESCE((SUM(plan_order_count)/SUM(click_count)),0) sum_conversion_rate").
      select("SUM(plan_order_count) sum_plan_order_count").
      select("SUM(final_order_count) sum_final_order_count").
      select("SUM(cancel_order_count) sum_cancel_order_count").
      select("SUM(plan_order_reward) sum_plan_order_reward").
      select("SUM(plan_order_net_reward) sum_plan_order_net_reward").
      select("SUM(final_order_reward) sum_final_order_reward").
      select("SUM(final_order_net_reward) sum_final_order_net_reward").
      select("SUM(final_all_reward) sum_final_all_reward").
      select("SUM(final_all_net_reward) sum_final_all_net_reward").
      select("year(dailies.created_on) year_created_on").
      select("month(dailies.created_on) month_created_on").
      joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted = 0 )').
      joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted = 0 )')
      @search = @sum_statistic.group(group_param).search(params[:search])
      @sum_statistic = @sum_statistic.search(params[:search])
      
      @radio_daily = "month"
    
    if params[:search][:created_on_lt].blank?
      year = @search.first.year_created_on
      month = @search.first.month_created_on
    else
      year = Date.parse(params[:search][:created_on_lt]).year
      month = Date.parse(params[:search][:created_on_lt]).month
    end
    
    unless params[:search][:created_on_gt].blank?
      end_year = Date.parse(params[:search][:created_on_gt]).year
      end_month = Date.parse(params[:search][:created_on_gt]).month
    end
    count = 0
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << Statistic.admin_header_to_sjis
          @search.each do |row|
            unless search_attributes?
              while year > row.year_created_on
                while month > 0
                  csv << [year.to_s+"-"+month.to_s,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
                  if month == 1
                    month = 12
                    year = year - 1
                    count = count + 1
                    break
                  else
                    month = month - 1
                    count = count + 1
                  end
                end
              end
              if year == row.year_created_on
                while month > row.month_created_on
                  csv << [year.to_s+"-"+month.to_s,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
                  month = month - 1
                  count = count + 1
                end
              end
              if month == 1
                month = 12
                year = year - 1
                count = count + 1
              else
                month = month -1
                count = count + 1
              end
            end
            csv << [row.year_created_on.to_s+"-"+row.month_created_on.to_s,
                    row.sum_impression_count,
                    row.sum_click_count,
                    row.sum_click_valid_count,
                    row.sum_click_rate,
                    row.sum_final_click_reward,
                    row.sum_conversion_rate,
                    row.sum_plan_order_count,
                    row.sum_final_order_count,
                    row.sum_cancel_order_count,
                    row.sum_plan_order_reward,
                    row.sum_plan_order_net_reward,
                    row.sum_final_order_reward,
                    row.sum_final_order_net_reward,
                    row.sum_final_all_reward,
                    row.sum_final_all_net_reward
                    ]
          end
          unless search_attributes?
            unless params[:search][:created_on_gt].blank?
              while year > end_year
                while month > 0
                  csv << [year.to_s+"-"+month.to_s,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
                  if month == 1
                    month = 12
                    year = year - 1
                    count = count + 1
                    break
                  else
                    month = month - 1
                    count = count + 1
                  end
                end
              end
              if year == end_year
                while month >= end_month
                  csv << [year.to_s+"-"+month.to_s,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
                  month = month - 1
                  count = count + 1
                end
              end
            end
          end
          @sum_statistic.each do |row|
            csv << ["総計",
                    row.sum_impression_count,
                    row.sum_click_count,
                    row.sum_click_valid_count,
                    row.sum_click_rate,
                    row.sum_final_click_reward,
                    row.sum_conversion_rate,
                    row.sum_plan_order_count,
                    row.sum_final_order_count,
                    row.sum_cancel_order_count,
                    row.sum_plan_order_reward,
                    row.sum_plan_order_net_reward,
                    row.sum_final_order_reward,
                    row.sum_final_order_net_reward,
                    row.sum_final_all_reward,
                    row.sum_final_all_net_reward
                    ]
            csv << ["総平均",
                    (row.sum_impression_count.to_f / count).round(2),
                    (row.sum_click_count.to_f / count).round(2),
                    (row.sum_click_valid_count.to_f / count).round(2),
                    row.sum_click_rate,
                    (row.sum_final_click_reward.to_f / count).round(2),
                    row.sum_conversion_rate,
                    (row.sum_plan_order_count.to_f / count).round(2),
                    (row.sum_final_order_count.to_f / count).round(2),
                    (row.sum_cancel_order_count.to_f / count).round(2),
                    (row.sum_plan_order_reward.to_f / count).round(2),
                    (row.sum_plan_order_net_reward.to_f / count).round(2),
                    (row.sum_final_order_reward.to_f / count).round(2),
                    (row.sum_final_order_net_reward.to_f / count).round(2),
                    (row.sum_final_all_reward.to_f / count).round(2),
                    (row.sum_final_all_net_reward.to_f / count).round(2),
                    ]
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => self.csv_name)
      end
    end
  end

  def upload
    @statistic = Daily.new
  end

  def uploaded
    @statistics, @error_statistics = [], []
    Promotion.transaction do
      CSV.parse(params[:daily][:file].read).each do |line|
        next if line.empty?

        id = line[0]
        statistic = Daily.find_by_id(id) || Daily.new
        statistic.attributes = {
          :impression_count => line[1],
          :click_count => line[2],
        }
        statistic.save! if statistic.valid?

        if statistic.valid?
          @statistics << statistic 
        else
          @error_statistics << statistic
        end
      end
    end

  end

  # promotionに紐づかれたsiteのid,nameを返す
  def promotion_publishes_sites
    promotion_ids = params[:promotion_id].split(':')
    logger.debug promotion_ids
    int_promotion_ids = promotion_ids.uniq.map{|str| str.to_i }
    respond_to do |format|
      format.html
      format.json{ render :json => Promotion.sites_options_for_select(@client.id, int_promotion_ids)}
    end
  end

protected
  def find_client 
     @client = Client.find(params[:client_id])
  end
  
  def csv_name
    "#{params[:controller]}_#{params[:client_id]}.csv"
  end

  def find_site
    @sites = Site.belong_to_client @client
    return @sites.uniq
  end
  
  def search_promotion?
    promotion_flg = false
    unless params[:search].nil?
      unless params[:search][:promotion_id_in].nil?
        unless params[:search][:promotion_id_in].empty?
          promotion_flg = true
        end
      end
    end

    return promotion_flg
  end
  
  def search_id?
    site_flg = false
    unless params[:search].nil?
      unless params[:search][:site_id_in].nil?
        unless params[:search][:site_id_in].empty?
          site_flg = true
        end
      end
    end

    return site_flg
  end


  def authority_required
    unless current_admin.super_user?
      @client = Client.find(params[:client_id])
      unless @client.admins.include? current_admin
        raise ActiveRecord::RecordNotFound
      end
    end
  end
  
  def search_attributes?
    search_attributes = true
    if params[:search].nil?
      search_attributes = false
    else
      if params[:search][:impression_count_gt].blank?
        if params[:search][:impression_count_lt].blank?
          if params[:search][:click_count_gt].blank?
            if params[:search][:click_count_lt].blank?
              if params[:search][:click_valid_count_gt].blank?
                if params[:search][:click_valid_count_lt].blank?
                  if params[:search][:click_rate_gt].blank?
                    if params[:search][:click_rate_lt].blank?
                      if params[:search][:final_click_reward_gt].blank?
                        if params[:search][:final_click_reward_lt].blank?
                          if params[:search][:conversion_rate_gt].blank?
                            if params[:search][:conversion_rate_lt].blank?
                              if params[:search][:plan_order_count_gt].blank?
                                if params[:search][:plan_order_count_lt].blank?
                                  if params[:search][:final_order_count_gt].blank?
                                    if params[:search][:final_order_count_lt].blank?
                                      if params[:search][:cancel_order_count_gt].blank?
                                        if params[:search][:cancel_order_count_lt].blank?
                                          if params[:search][:plan_order_reward_gt].blank?
                                            if params[:search][:plan_order_reward_lt].blank?
                                              if params[:search][:plan_order_net_reward_gt].blank?
                                                if params[:search][:plan_order_net_reward_lt].blank?
                                                  if params[:search][:final_order_reward_gt].blank?
                                                    if params[:search][:final_order_reward_lt].blank?
                                                      if params[:search][:final_order_net_reward_gt].blank?
                                                        if params[:search][:final_order_net_reward_lt].blank?
                                                          if params[:search][:final_all_reward_gt].blank?
                                                            if params[:search][:final_all_reward_lt].blank?
                                                              if params[:search][:final_all_net_reward_gt].blank?
                                                                if params[:search][:final_all_net_reward_lt].blank?
                                                                  unless search_id?
                                                                    unless search_promotion?
                                                                      search_attributes = false
                                                                    end
                                                                  end
                                                                end
                                                              end
                                                            end
                                                          end
                                                        end
                                                      end
                                                    end
                                                  end
                                                end
                                              end
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    return search_attributes
  end
end