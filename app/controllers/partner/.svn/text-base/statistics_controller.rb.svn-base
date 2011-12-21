# encoding: utf-8
class Partner::StatisticsController < Admin::StatisticsController
  layout 'partner'

  skip_before_filter :authenticate_admin!
  skip_before_filter :authority_required
  skip_before_filter :find_client 
  before_filter :authenticate_partner!
  before_filter :find_partner 

  def index
    @selected_promotions = []
    @display_promotions = []
    @selected_sites = []
    @display_sites = []
    group_param = ["dailies.created_on"]
    unless params[:publishList].nil?
      unless params[:publishList][:promotion_id].nil?
        unless params[:publishList][:promotion_id].empty?
          promotion_flg = true
          group_param.push "dailies.promotion_id"
          promotions = Promotion.find params[:publishList][:promotion_id]
          promotions.each do |promotion|
            @selected_promotions << promotion.id
            @display_promotions << promotion.name
          end
        end
      end
    end
    unless params[:publishList].nil?
      unless params[:publishList][:site_id].nil?
        unless params[:publishList][:site_id].empty?
          site_flg = true
          group_param.push "dailies.site_id"
          sites = Site.find params[:publishList][:site_id]
          sites.each do |site|
            @selected_sites << site.id
            @display_sites << site.name
          end
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
    
    if !promotion_flg && !site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("dailies.created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)')
    elsif promotion_flg && !site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("dailies.created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        where('dailies.promotion_id IN (?)', params[:publishList][:promotion_id])
    elsif !promotion_flg && site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("dailies.created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        where('dailies.site_id IN (?)', params[:publishList][:site_id])
    elsif promotion_flg && site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("dailies.created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        select("site_id").
        where('dailies.promotion_id IN (?) AND dailies.site_id IN (?) ', params[:publishList][:promotion_id], params[:publishList][:site_id])
    end
    @search = @sum_statistic.group(group_param).search(params[:search])
    @sum_statistic = @sum_statistic.search(params[:search])
    
    @statistics = @search.page(params[:page]).per(params[:per])
    @promotions = @partner.promotions
    @sites = @partner.sites
    @radio_daily = "week"

    if @search.all.blank?
      flash[:notice] = t("flash.notice.no_data")
    end
      
    respond_to do |format|
      format.html
    end
  end

  def index_month
    @selected_promotions = []
    @display_promotions = []
    @selected_sites = []
    @display_sites = []
    group_param = ["year(dailies.created_on)", "month(dailies.created_on)"]
    promotion_flg = false
    site_flg = false
    unless params[:publishList].nil?
      unless params[:publishList][:promotion_id].nil?
        unless params[:publishList][:promotion_id].empty?
          promotion_flg = true
          group_param.push "dailies.promotion_id"
          promotions = Promotion.find params[:publishList][:promotion_id]
          promotions.each do |promotion|
            @selected_promotions << promotion.id
            @display_promotions << promotion.name
          end
        end
      end
    end
    unless params[:publishList].nil?
      unless params[:publishList][:site_id].nil?
        unless params[:publishList][:site_id].empty?
          site_flg = true
          group_param.push "dailies.site_id"
          sites = Site.find params[:publishList][:site_id]
          sites.each do |site|
            @selected_sites << site.id
            @display_sites << site.name
          end
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
    
    if !promotion_flg && !site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("year(dailies.created_on) year_created_on").
        select("month(dailies.created_on) month_created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)')
    elsif promotion_flg && !site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("year(dailies.created_on) year_created_on").
        select("month(dailies.created_on) month_created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        where('dailies.promotion_id IN (?)', params[:publishList][:promotion_id])
    elsif !promotion_flg && site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("year(dailies.created_on) year_created_on").
        select("month(dailies.created_on) month_created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        where('dailies.site_id IN (?)', params[:publishList][:site_id])
    elsif promotion_flg && site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("year(dailies.created_on) year_created_on").
        select("month(dailies.created_on) month_created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        select("site_id").
        where('dailies.promotion_id IN (?) AND dailies.site_id IN (?) ', params[:publishList][:promotion_id], params[:publishList][:site_id])
    end
    @search = @sum_statistic.group(group_param).search(params[:search])
    @sum_statistic = @sum_statistic.search(params[:search])    
    @statistics = @search.page(params[:page]).per(params[:per])
    @promotions = @partner.promotions
    @sites = @partner.sites
    @radio_daily = "month"

    if @search.all.blank?
      flash[:notice] = t("flash.notice.no_data")
    end
      
    respond_to do |format|
      format.html {render :action => 'index'}
    end
  end
  
  def csv
    
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
    unless params[:publishList].nil?
      unless params[:publishList][:promotion_id].nil?
        unless params[:publishList][:promotion_id].empty?
          promotion_flg = true
          group_param.push "dailies.promotion_id"
        end
      end
    end
    
    unless params[:publishList].nil?
      unless params[:publishList][:site_id].nil?
        unless params[:publishList][:site_id].empty?
          site_flg = true
          group_param.push "dailies.site_id"
        end
      end
    end

    if !promotion_flg && !site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("dailies.created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)')
    elsif promotion_flg && !site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("dailies.created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        where('dailies.promotion_id IN (?)', params[:publishList][:promotion_id])
    elsif !promotion_flg && site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("dailies.created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        where('dailies.site_id IN (?)', params[:publishList][:site_id])
    elsif promotion_flg && site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("dailies.created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        select("site_id").
        where('dailies.promotion_id IN (?) AND dailies.site_id IN (?) ', params[:publishList][:promotion_id], params[:publishList][:site_id])
    end
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
          csv << Statistic.header_to_sjis
          @search.each do |row|
            unless search_attributes?
              while date > row.created_on
                csv << [date,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0]
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
                    row.sum_final_order_reward,
                    row.sum_final_all_reward,
                    ]
          end
          unless search_attributes?
            unless params[:search][:created_on_gt].blank?
              while date >= end_date
                csv << [date,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0]
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
                    row.sum_final_order_reward,
                    row.sum_final_all_reward
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
                    row.sum_final_order_reward.nil? ? 0 : (row.sum_final_order_reward / count).round(2),
                    row.sum_final_all_reward.nil? ? 0 : (row.sum_final_all_reward / count).round(2),
                    ]
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => self.csv_name)
      end
    end
  end
  
  def csvmonth
    
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
    group_param = ["year(dailies.created_on)", "month(dailies.created_on)"]
    unless params[:publishList].nil?
      unless params[:publishList][:promotion_id].nil?
        unless params[:publishList][:promotion_id].empty?
          promotion_flg = true
          group_param.push "dailies.promotion_id"
        end
      end
    end
    
    unless params[:publishList].nil?
      unless params[:publishList][:site_id].nil?
        unless params[:publishList][:site_id].empty?
          site_flg = true
          group_param.push "dailies.site_id"
        end
      end
    end

    if !promotion_flg && !site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("year(dailies.created_on) year_created_on").
        select("month(dailies.created_on) month_created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)')
    elsif promotion_flg && !site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("year(dailies.created_on) year_created_on").
        select("month(dailies.created_on) month_created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        where('dailies.promotion_id IN (?)', params[:publishList][:promotion_id])
    elsif !promotion_flg && site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("year(dailies.created_on) year_created_on").
        select("month(dailies.created_on) month_created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        where('dailies.site_id IN (?)', params[:publishList][:site_id])
    elsif promotion_flg && site_flg
      @sum_statistic = @partner.
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
        select("SUM(CASE WHEN clients.consigned = 1 THEN plan_order_net_reward ELSE plan_order_reward END) sum_plan_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_order_net_reward ELSE final_order_reward END) sum_final_order_reward").
        select("SUM(CASE WHEN clients.consigned = 1 THEN final_all_net_reward ELSE final_all_reward END) sum_final_all_reward").
        select("year(dailies.created_on) year_created_on").
        select("month(dailies.created_on) month_created_on").
        joins('LEFT JOIN sites ON (dailies.site_id = sites.id AND sites.deleted <> 1 )').
        joins('LEFT JOIN promotions ON (dailies.promotion_id = promotions.id AND promotions.deleted <> 1 )').
        joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted <> 1)').
        select("promotion_id").
        select("site_id").
        where('dailies.promotion_id IN (?) AND dailies.site_id IN (?) ', params[:publishList][:promotion_id], params[:publishList][:site_id])
    end
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
          csv << Statistic.header_to_sjis
          @search.each do |row|
            unless search_attributes?
              while year > row.year_created_on
                while month > 0
                  csv << [year.to_s+"-"+month.to_s,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0]
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
                  csv << [year.to_s+"-"+month.to_s,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0]
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
                    row.sum_final_order_reward,
                    row.sum_final_all_reward,
                    ]
          end
          unless search_attributes?
            unless params[:search][:created_on_gt].blank?
              while year > end_year
                while month > 0
                  csv << [year.to_s+"-"+month.to_s,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0]
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
                  csv << [year.to_s+"-"+month.to_s,0.0,0.0,0.0,0.000,0.0,0.000,0.0,0.0,0.0,0.0,0.0,0.0]
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
                    row.sum_final_order_reward,
                    row.sum_final_all_reward
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
                    row.sum_final_order_reward.nil? ? 0 : (row.sum_final_order_reward / count).round(2),
                    row.sum_final_all_reward.nil? ? 0 : (row.sum_final_all_reward / count).round(2),
                    ]
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => self.csv_name)
      end
    end
  end
  
protected
  def find_partner
     @partner = current_partner
  end

  def csv_name
    "#{params[:controller]}.csv"
  end
end