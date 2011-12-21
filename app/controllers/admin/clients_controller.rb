# -*- coding: utf-8 -*-
require 'csv'

class Admin::ClientsController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!
  before_filter :declare_consigned_work!, :only => [ :top ]
  before_filter :authority_required, :only =>[:show, :edit, :update, :delete, :destroy]

  def index
    if current_admin.super_user?
      @search = Client.unscoped{ Client.search(params[:search]) }
      @clients = Client.unscoped{ @search.page(params[:page]).per(params[:per]) }
    else
      @search = current_admin.clients.search(params[:search])
      @clients = @search.page(params[:page]).per(params[:per])
    end

    if @search.all.blank?
      flash[:notice] = t("flash.notice.no_data")
    end

    respond_to do |format|
      format.html
    end
  end
  
  def csv
    if current_admin.super_user?
      @search = Client.unscoped{ Client.search(params[:search]) }
      header = %w(login_id email company_name site_url consigned registration_status deleted)
    else
      @search = Client.search(params[:search])
      header = %w(login_id email company_name site_url consigned registration_status)
    end

    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << header.map{|head| Client.human_attribute_name(head).encode("CP932")}
          @search.each do |row|
            if row.consigned then consigned = "受託" else consigned = "一般" end
            if row.deleted then deleted = "削除済み" else deleted = "削除していません" end
            if current_admin.super_user?
              csv << [row.login_id, row.email, row.company_name, row.site_url, consigned, Client::REGISTRATION_STATUSES[row.registration_status], deleted]
            else
              csv << [row.login_id, row.email, row.company_name, row.site_url, consigned, Client::REGISTRATION_STATUSES[row.registration_status]]
            end
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => self.csv_name)
      end
    end
  end

  def show
    find_client
    @account_managements = @client.account_managements

    respond_to do |format|
      format.html
    end
  end

  def new
    @client = Client.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    find_client
    
    respond_to do |format|
      format.html
    end
  end

  def create
    @client = Client.new
    @client.send(:attributes=, params[:client], false)
    unless current_admin.super_user?
      @client.admins << current_admin
    end
    respond_to do |format|
      if @client.save
          flash[:notice] = t("flash.notice.created")
          format.html { redirect_to admin_clients_path }
      else
        flash[:error] = t("flash.error.create_failed")
        format.html { render :action => "new" }
      end
    end
  end

  def update
    find_client
    @client.send(:attributes=, params[:client], false)

    respond_to do |format|
      if @client.save
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to polymorphic_url( [:admin, @client] ) }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "edit" }
      end
    end
  end

  def delete
    find_client
  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        find_client
        unless @client.account_management.nil?
          @account_management = @client.account_management
          @account_management.destroy
        end
          if !@client.promotions.empty? && !@client.publishes.empty?
            promotion_ids = []
            publish_ids = []
            @client.promotions.each do |data|
              promotion_ids = promotion_ids.push data
            end
            @client.publishes.each do |data|
              publish_ids = publish_ids.push data
            end
            raise 'Promotion Update Error' unless Promotion.update_all ['deleted = ? ', "true"], ['id in (?)', promotion_ids]
            raise 'Publish Update Error' unless Publish.update_all ['deleted = ? ', "true"], ['id in (?)', publish_ids]

            @client.deleted = true
            @client.save!
          elsif !@client.promotions.empty? && @client.publishes.empty?
            promotion_ids = []
            @client.promotions.each do |data|
              promotion_ids = promotion_ids.push data
            end
            raise 'Promotion Update Error' unless Promotion.update_all ['deleted = ? ', "true"], ['id in (?)', promotion_ids]
            @client.deleted = true
            @client.save!
          elsif @client.promotions.empty? && @client.publishes.empty?
            @client.deleted = true
            @client.save!
          end
      rescue
        respond_to do |format|
            flash[:error] = t("flash.error.delete_failed")
            format.html { redirect_to :action => :index }
        end
      else
        respond_to do |format|
          flash[:notice] = t("flash.notice.deleted")
          format.html { redirect_to :action => :index }
        end
      ensure
      end
    end
  end

  def top
    find_client

    respond_to do |format|
      format.html
    end
  end

  # promotionに紐づかれたsiteのid,nameをjsonで返す
  def promotion_publishes_sites
    respond_to do |format|
      format.html
      format.json{ render :json => Promotion.publishes_sites_options_for_select(@client.id, params[:promotion_id])}
    end
  end
  
  def client_id?
    client_flg = false
    unless params[:search].nil?
      unless params[:search][:id_in].nil?
        unless params[:search][:id_in].empty?
          client_flg = true
        end
      end
    end

    return client_flg
  end

protected
  def csv_name
    "#{params[:controller]}_#{params[:client_id]}.csv"
  end

private
  def find_client
    if current_admin.super_user?
      @client = Client.including_deleted.find(params[:id])
    else
      @client = Client.find(params[:id])
    end
  end
  
  def authority_required
    unless current_admin.super_user?
      @client = Client.find(params[:id])
      unless @client.admins.include? current_admin
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end