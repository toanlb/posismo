# -*- coding: utf-8 -*-
require 'csv'

class Partner::SitesController < ApplicationController
  layout 'partner'

  before_filter :authenticate_partner!, :except => :child_categories
  before_filter :find_partner, :except => :child_categories

  def index
    @search = @partner.sites.search(params[:search])
    @sites = @search.page(params[:page]).per(params[:per])

    respond_to do |format|
      format.html
    end
  end
  
  def csv
    @search = @partner.sites.search(params[:search])

    header = %w(ID サイト名 URL 備考 キーワード)
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << header.map{|head| head.encode("CP932")}
          @search.each do |row|
            csv << [row.id, row.name, row.url, row.description, row.keywords ]
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => "sites.csv")
      end
    end
  end
  
  def show
    @site = @partner.sites.find(params[:id])
    @categories = @site.categories_sites.includes([:category]).order(:id).limit(CategoriesSite::LIMIT_PER_SITE)

    respond_to do |format|
      format.html
    end
  end

  def new
    @site = @partner.sites.new
    @parent_options = Category.parent_category_options_for_select

    respond_to do |format|
      format.html
    end
  end

  def edit
    @site = @partner.sites.find(params[:id])
    @categories_sites = @site.categories_sites.includes(:category).order(:id)
    @parent_options = Category.parent_category_options_for_select
    @child_options = []
    @categories_sites.each do |category_site|
      @child_options << Category.child_category_options_for_select(category_site.category.parent_id || category_site.category_id)
    end

    respond_to do |format|
      format.html
    end
  end

  def create
    @site = @partner.sites.new(params[:site])

    respond_to do |format|
      begin
        @site.save!
        @categories_sites = []
        params[:categories_sites].each do |key, categories_site|
          category_id = categories_site[:category_id].blank? ? categories_site[:parent_category_id] : categories_site[:category_id]
          next if category_id.blank?

          new = CategoriesSite.new({:category_id => category_id})
          new.site_id = @site.id
          @categories_sites << new
        end
        CategoriesSite.transaction{@categories_sites.each(&:save)}

        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to polymorphic_url( [:partner, @site] ) }
      rescue
        flash[:error] = t("flash.error.save_failed")
        @parent_options = Category.parent_category_options_for_select
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @site = @partner.sites.find(params[:id])

    respond_to do |format|
      begin
        @site.update_attributes(params[:site])
        @categories_sites = @site.categories_sites.order(:id)

        CategoriesSite.transaction do
          params[:categories_sites].each do |key, param_categories_site|
            categories_site = @categories_sites[key.to_i]
            if param_categories_site[:category_id].blank? && param_categories_site[:parent_category_id].blank?
              categories_site.try(:delete) 
              next
            end

            category_id = param_categories_site[:category_id].blank? ? param_categories_site[:parent_category_id] : param_categories_site[:category_id]

            if categories_site.nil?
              categories_site = CategoriesSite.new({:category_id => category_id})
              categories_site.site_id = @site.id
            else
              categories_site.category_id = category_id
            end
            categories_site.save
          end

        end

        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to polymorphic_url( [:partner, @site] ) }
      rescue
        flash[:error] = t("flash.error.save_failed")
        @options = Category.category_options_for_select
        format.html { render :action => "edit" }
      end
    end
  end

  def delete
    @site = @partner.sites.find(params[:id])
  end

  def destroy
    @site = @partner.sites.find(params[:id])
    @site.deleted = true
    @site.check_related_publishes
    
    respond_to do |format|
      if @site.save
        flash[:notice] = t("flash.notice.deleted")
        format.html { redirect_to :action => :index }
      else
        flash[:notice] = t("flash.error.delete_failed")
        format.html { redirect_to :action => :index }
      end
    end
  end

  def child_categories
    respond_to do |format|
      format.html
      format.json{ render :json => Category.child_category_options_for_select(params[:parent_id])}
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
