# encoding: utf-8
class Client::StatisticsController < Admin::StatisticsController
  layout 'client'

  skip_before_filter :authenticate_admin!
  skip_before_filter :authority_required
  before_filter :authenticate_client! 

  def index
    group_param = ["dailies.client_id", "dailies.created_on"]
    promotion_flg = false
    site_flg = false
    unless params[:publish].nil?
      unless params[:publish][:promotion_id].nil?
        unless params[:publish][:promotion_id].empty?
          promotion_flg = true
          group_param.push "dailies.promotion_id"
        end
      end
    end
    unless params[:publish].nil?
      unless params[:publish][:site_id].nil?
        unless params[:publish][:site_id].empty?
          site_flg = true
          group_param.push "dailies.site_id"
        end
      end
    end
    
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
        select("SUM(final_order_reward) sum_final_order_reward").
        select("SUM(final_all_reward) sum_final_all_reward").
        select("dailies.created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )')
        
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
  
  
  def index_month
    group_param = ["dailies.client_id", "year(dailies.created_on)", "month(dailies.created_on)"]
    #デフォルトソート設定
    if params[:search].nil?
      params[:search] = {:meta_sort => 'created_on.desc'}
    else if params[:search][:meta_sort].nil?
        params[:search][:meta_sort]='created_on.desc'
      end
    end
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
      select("SUM(final_order_reward) sum_final_order_reward").
      select("SUM(final_all_reward) sum_final_all_reward").
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
      select("SUM(final_order_reward) sum_final_order_reward").
      select("SUM(final_all_reward) sum_final_all_reward").
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
    blank_data = [date,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0]
    unless current_client.consigned
      blank_data = blank_data + [0.0,0.0,0.0]
    end
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          if current_client.consigned
            csv << Statistic.consigned_header_to_sjis
          else
            csv << Statistic.header_to_sjis
          end
          @search.each do |row|
            unless search_attributes?
              while date > row.created_on
                csv << blank_data
                date = date - 1
                count = count + 1
              end
              date = date - 1
              count = count + 1
            end
            statistic_data = [row.created_on,
                    row.sum_impression_count,
                    row.sum_click_count,
                    row.sum_click_valid_count,
                    row.sum_click_rate,
                    row.sum_final_click_reward,
                    row.sum_conversion_rate,
                    row.sum_plan_order_count,
                    row.sum_final_order_count,
                    row.sum_cancel_order_count
                    ]
            unless current_client.consigned
              statistic_data = statistic_data + [ row.sum_plan_order_reward, row.sum_final_order_reward, row.sum_final_all_reward ]
            end
            csv << statistic_data
          end
          unless search_attributes?
            unless params[:search][:created_on_gt].blank?
              while date >= end_date
                csv << blank_data
                date = date - 1
                count = count + 1
              end
            end
          end
          @sum_statistic.each do |row|
            statistic_data = [ "総計",
                    row.sum_impression_count,
                    row.sum_click_count,
                    row.sum_click_valid_count,
                    row.sum_click_rate,
                    row.sum_final_click_reward,
                    row.sum_conversion_rate,
                    row.sum_plan_order_count,
                    row.sum_final_order_count,
                    row.sum_cancel_order_count
                    ]
            unless current_client.consigned
              statistic_data = statistic_data + [row.sum_plan_order_reward, row.sum_final_order_reward, row.sum_final_all_reward ]
            end
            csv << statistic_data
            statistic_data = ["総平均",
                    row.sum_impression_count.nil? ? 0 : (row.sum_impression_count / count).round(2),
                    row.sum_click_count.nil? ? 0 : (row.sum_click_count / count).round(2),
                    row.sum_click_valid_count.nil? ? 0 : (row.sum_click_valid_count / count).round(2),
                    row.sum_click_rate,
                    row.sum_final_click_reward.nil? ? 0 : (row.sum_final_click_reward / count).round(2),
                    row.sum_conversion_rate,
                    row.sum_plan_order_count.nil? ? 0 : (row.sum_plan_order_count / count).round(2),
                    row.sum_final_order_count.nil? ? 0 : (row.sum_final_order_count / count).round(2),
                    row.sum_cancel_order_count.nil? ? 0 : (row.sum_cancel_order_count / count).round(2)
                  ]
            unless current_client.consigned
              statistic_data = statistic_data + [row.sum_plan_order_reward.nil? ? 0 : (row.sum_plan_order_reward / count).round(2),
                row.sum_final_order_reward.nil? ? 0 : (row.sum_final_order_reward / count).round(2),
                row.sum_final_all_reward.nil? ? 0 : (row.sum_final_all_reward / count).round(2)
                ]
            end
            csv << statistic_data
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => self.csv_name)
      end
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
      select("SUM(final_order_reward) sum_final_order_reward").
      select("SUM(final_all_reward) sum_final_all_reward").
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
    statistic_blank_data = [year.to_s+"-"+month.to_s,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0]
    unless current_client.consigned
      statistic_blank_data = statistic_blank_data + [0.0,0.0,0.0]
    end
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          if current_client.consigned
            csv << Statistic.consigned_header_to_sjis
          else
            csv << Statistic.header_to_sjis
          end
          @search.each do |row|
            blank_data = 
            unless search_attributes?
              while year > row.year_created_on
                while month > 0
                  csv << statistic_blank_data
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
                  csv << statistic_blank_data
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
            statistic_data = [row.year_created_on.to_s+"-"+row.month_created_on.to_s,
                    row.sum_impression_count,
                    row.sum_click_count,
                    row.sum_click_valid_count,
                    row.sum_click_rate,
                    row.sum_final_click_reward,
                    row.sum_conversion_rate,
                    row.sum_plan_order_count,
                    row.sum_final_order_count,
                    row.sum_cancel_order_count
                  ]
            unless current_client.consigned
              statistic_data = statistic_data + [row.sum_plan_order_reward, row.sum_final_order_reward, row.sum_final_all_reward]
            end
            csv << statistic_data
          end
          unless search_attributes?
            unless params[:search][:created_on_gt].blank?
              while year > end_year
                while month > 0
                  csv << statistic_blank_data
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
                  csv << statistic_blank_data
                  month = month - 1
                  count = count + 1
                end
              end
            end
          end
          @sum_statistic.each do |row|
            statistic_data = ["総計",
                    row.sum_impression_count,
                    row.sum_click_count,
                    row.sum_click_valid_count,
                    row.sum_click_rate,
                    row.sum_final_click_reward,
                    row.sum_conversion_rate,
                    row.sum_plan_order_count,
                    row.sum_final_order_count,
                    row.sum_cancel_order_count
                  ]
            unless current_client.consigned
              statistic_data = statistic_data + [row.sum_plan_order_reward, row.sum_final_order_reward, row.sum_final_all_reward]
            end
            csv << statistic_data
            statistic_data = ["総平均",
                    (row.sum_impression_count.to_f / count).round(2),
                    (row.sum_click_count.to_f / count).round(2),
                    (row.sum_click_valid_count.to_f / count).round(2),
                    row.sum_click_rate,
                    (row.sum_final_click_reward.to_f / count).round(2),
                    row.sum_conversion_rate,
                    (row.sum_plan_order_count.to_f / count).round(2),
                    (row.sum_final_order_count.to_f / count).round(2),
                    (row.sum_cancel_order_count.to_f / count).round(2)
                ]
            unless current_client.consigned
              statistic_data = statistic_data + [(row.sum_plan_order_reward.to_f / count).round(2),
                    (row.sum_final_order_reward.to_f / count).round(2),
                    (row.sum_final_all_reward.to_f / count).round(2)
                    ]
            end
            csv << statistic_data
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => self.csv_name)
      end
    end
  end
  
protected
  def find_client 
     @client = current_client
  end

  def csv_name
    "#{params[:controller]}.csv"
  end
end