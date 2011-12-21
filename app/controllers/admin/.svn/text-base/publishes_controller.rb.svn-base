# -*- coding: utf-8 -*-
require 'csv'
class Admin::PublishesController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!
  before_filter :find_client
  before_filter :declare_consigned_work!
  before_filter :authority_required

  def index
    @search = @client.publishes.joins(:site).search(params[:search])
    @publishes = @search.page(params[:page]).per(params[:per])
    @promotions = @client.promotions
    @sites = find_site
    @selected_promotions = []
    @selected_sites = []

    if search_promotion?
      promotions = Promotion.find params[:search][:promotion_id_in]
      promotions.each do |promotion|
        @selected_promotions << promotion.id
      end
    end

    if search_id?
      sites = Site.find params[:search][:site_id_in]
      sites.each do |site|
        @selected_sites << site.id
      end
    end

    respond_to do |format|
      format.html
    end
  end

  def csv
    @publishes = @client.publishes.joins(:site).search(params[:search])
    header = %w(プロモーション名 サイト名 承認状態)

    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << header.map{|head| Publish.human_attribute_name(head).encode("CP932")}
          @publishes.each do |row|
            if row.site.nil?
              csv << [row.promotion.name, "", row.approval_status]
            else
              csv << [row.promotion.name, row.site.name, row.approval_status]
            end
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => self.csv_name)
      end
    end
  end

  def show
    @publish = @client.publishes.find(params[:id])
    @promotion = @publish.promotion
    @site = @publish.site
  end

  def approve
    @publish = Publish.find(params[:id])
    if @publish.approve!
      flash[:notice] = t("flash.notice.publish_approved")
      redirect_to :action => :show
    else
      flash[:error] = t("flash.error.publish_approval_failed")
      redirect_to :action => :show
    end
  end
  def reject
    @publish = Publish.find(params[:id])
    if @publish.reject!
      flash[:notice] = t("flash.notice.publish_rejected")
      redirect_to :action => :show
    else
      flash[:error] = t("flash.error.publish_rejection_failed")
      redirect_to :action => :show
    end
  end
  def defer
    @publish = Publish.find(params[:id])
    if @publish.defer!
      flash[:notice] = t("flash.notice.publish_deferred")
      redirect_to :action => :show
    else
      flash[:error] = t("flash.error.publish_deferment_failed")
      redirect_to :action => :show
    end
  end

  def upload
    @publish = @client.publishes.new
  end

  def uploaded
    @publishes, @error_publishes = [], []

    begin
      Promotion.transaction do
        CSV.parse(params[:publish][:file].read).each do |line|
          next if line.empty?

          id = line[0]
          publish = @client.publishes.find_by_id(id) || @client.publishes.new
          publish.attributes = {
            :promotion_id => Promotion.find_by_name(line[1]).try(:id),
            :site_id => Site.find_by_name(line[2]).try(:id),
            :approval_status => line[3]
          }
          publish.save! if publish.valid?

          if publish.valid?
            @publishes << publish 
          else
            @error_publishes << publish
          end
        end
      end

    rescue
      redirect_to :action => :upload
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
  end
  
  def authority_required
    unless current_admin.super_user?
      @client = Client.find(params[:client_id])
      unless @client.admins.include? current_admin
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end