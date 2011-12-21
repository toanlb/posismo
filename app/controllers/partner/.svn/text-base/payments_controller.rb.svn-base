# -*- coding: utf-8 -*-
require 'csv'

class Partner::PaymentsController < ApplicationController
  layout 'partner'

  before_filter :authenticate_partner!
  before_filter :find_partner
  before_filter :approved?

  def index
    group_param = ["dailies.client_id","clients.company_name","dailies.created_on"]

    @search = @partner.
       dailies.
       select("clients.company_name").
       select("SUM(final_all_reward) sum_final_all_reward").
       select("dailies.created_on")
    unless params[:search].nil?
      unless params[:search][:promotion_id_eq].nil?
        unless params[:search][:promotion_id_eq].empty?
          group_param.push "dailies.promotion_id"
          @search = @search.select("promotion_id")
        end
      end
    end
    unless params[:search].nil?
      unless params[:search][:site_id_eq].nil?
        unless params[:search][:site_id_eq].empty?
          group_param.push "dailies.site_id"
          @search = @search.select("site_id")
        end
      end
    end
    unless params[:search].nil?
      unless params[:search][:client_id_eq].nil?
        unless params[:search][:client_id_eq].empty?
          group_param.push "dailies.client_id"
          @search = @search.select("dailies.client_id")
        end
      end
    end
    @search = @search.joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted = 0 )')
    @search = @search.joins('LEFT JOIN sites ON ( dailies.site_id = sites.id AND sites.deleted = 0 )')
    @search = @search.joins('LEFT JOIN promotions ON ( dailies.promotion_id = promotions.id AND promotions.deleted = 0 )')
    @search = @search.group(group_param).
    search(params[:search])

    @payments = @search.page(params[:page]).per(params[:per])
    @clients = @partner.clients

    respond_to do |format|
      format.html
    end
  end
  
  def csv
    group_param = ["dailies.client_id","clients.company_name","dailies.created_on"]

    @search = @partner.
       dailies.
       select("clients.company_name").
       select("SUM(final_all_reward) sum_final_all_reward").
       select("dailies.created_on")
    unless params[:search].nil?
      unless params[:search][:promotion_id_eq].nil?
        unless params[:search][:promotion_id_eq].empty?
          group_param.push "dailies.promotion_id"
          @search = @search.select("promotion_id")
        end
      end
    end
    unless params[:search].nil?
      unless params[:search][:site_id_eq].nil?
        unless params[:search][:site_id_eq].empty?
          group_param.push "dailies.site_id"
          @search = @search.select("site_id")
        end
      end
    end
    unless params[:search].nil?
      unless params[:search][:client_id_eq].nil?
        unless params[:search][:client_id_eq].empty?
          group_param.push "dailies.client_id"
          @search = @search.select("dailies.client_id")
        end
      end
    end
    @search = @search.joins('LEFT JOIN clients ON (dailies.client_id = clients.id AND clients.deleted = 0 )')
    @search = @search.joins('LEFT JOIN sites ON ( dailies.site_id = sites.id AND sites.deleted = 0 )')
    @search = @search.joins('LEFT JOIN promotions ON ( dailies.promotion_id = promotions.id AND promotions.deleted = 0 )')
    @search = @search.group(group_param).
    search(params[:search])

    header = %w(会社名 全確定報酬 注文日)
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << header.map{|head| head.encode("CP932")}
          @search.each do |row|
            csv << [row.company_name, row.sum_final_all_reward, row.created_on.strftime("%Y/%m/%d") ]
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => "payments.csv")
      end
    end
  end

protected
  def approved?
     redirect_to partner_account_thanks_path unless @partner.approved?
  end

private
  def find_partner
     @partner = current_partner
  end
  
  def csv_name
    "#{params[:controller]}_#{params[:client_id]}.csv"
  end
  def find_site
    @site = current_partner.sites
  end

end