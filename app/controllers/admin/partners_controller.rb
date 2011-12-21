# -*- coding: utf-8 -*-
require 'csv'

class Admin::PartnersController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!

  def index
    if current_admin.super_user?
      @search = Client.unscoped{ Partner.search(params[:search]) }
    else
      @search = Partner.search(params[:search])
    end

    @partners = @search.page(params[:page]).per(params[:per])

    if @search.all.blank?
      flash[:notice] = t("flash.notice.no_data")
    end

    respond_to do |format|
      format.html
    end
  end
  
  def csv
    if current_admin.super_user?
      @search = Partner.unscoped{ Partner.search(params[:search]) }
      header = %w(login_id email company_name contract_type manager_name registration_status deleted)
    else
      @search = Partner.search(params[:search])
      header = %w(login_id email company_name contract_type manager_name registration_status)
    end

    respond_to do |format|
      format.csv do
        csv_data = CSV.generate { |csv|
          csv << header.map{|head| Partner.human_attribute_name(head).encode("CP932")}
          @search.each do |row|
            if row.deleted then deleted = "削除済み" else deleted = "削除していません" end
            if current_admin.super_user?
              csv << [row.login_id, row.email, row.company_name, Partner::REGISTRATION_STATUSES[row.contract_type], row.manager_name, Partner::REGISTRATION_STATUSES[row.registration_status], deleted]
            else
              csv << [row.login_id, row.email, row.company_name, Partner::REGISTRATION_STATUSES[row.contract_type], row.manager_name, Partner::REGISTRATION_STATUSES[row.registration_status]]
            end
          end
        }
        send_data(csv_data, :type => 'text/csv', :filename => self.csv_name)
      end
    end
  end

  def show
    find_partner
    @site = Site.new

    respond_to do |format|
      format.html
    end
  end

  def new
    @partner = Partner.new

    @site = Site.new(params[:site]) || Site.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    find_partner
    
    respond_to do |format|
      format.html
    end
  end

  def create
    @partner = Partner.new
    @site = Site.new(params[:site])

    @partner.send(:attributes=, params[:partner], false)
    respond_to do |format|
      begin
        Partner.transaction do
          @partner.save!
          @site.partner_id = @partner.id
          @site.save!
        end
        flash[:notice] = t("flash.notice.created")
        format.html { redirect_to polymorphic_url( [:admin, @partner] ) }
      rescue
        flash[:error] = t("flash.error.create_failed")
        format.html { render :action => "new" }
      end
    end
  end

  def update
    find_partner
    @partner.send(:attributes=, params[:partner], false)
    
    respond_to do |format|
      if @partner.save
        flash[:notice] = t("flash.notice.saved")
        format.html { redirect_to polymorphic_url( [:admin, @partner] ) }
      else
        flash[:error] = t("flash.error.save_failed")
        format.html { render :action => "edit" }
      end
    end
  end
  
  def delete
    find_partner
  end

  def destroy
    find_partner
    @partner.deleted = true

    respond_to do |format|
      if @partner.save
        flash[:notice] = t("flash.notice.deleted")
        format.html { redirect_to :action => :index }
      else
        flash[:error] = t("flash.error.delete_failed")
        format.html { redirect_to :action => :index }
      end
    end
  end

  def top
    find_partner
    
    respond_to do |format|
      format.html
    end
  end

  def approve
    unless params[:check_ids].nil?
      Partner.where(["id IN (?)", params[:check_ids].values]).
        readonly(false).
        each do
      |partner|
        partner.approve!
      end
    end

    redirect_to :action => :index
  end

  def reject
    unless params[:check_ids].nil?
      Partner.where(["id IN (?)", params[:check_ids].values]).
        readonly(false).
        each do
      |partner|
        partner.reject!
      end
    end

    redirect_to :action => :index
  end

  def interim
    unless params[:check_ids].nil?
      Partner.where(["id IN (?)", params[:check_ids].values]).
        readonly(false).
        each do
      |partner|
        partner.interim!
      end
    end

    redirect_to :action => :index
  end
  
  def partner_id?
    partner_flg = false
    unless params[:search].nil?
      unless params[:search][:id_in].nil?
        unless params[:search][:id_in].empty?
          partner_flg = true
        end
      end
    end

    return partner_flg
  end
  
protected
  def csv_name
    "#{params[:controller]}_#{params[:client_id]}.csv"
  end

private
  def find_partner
    if current_admin.super_user?
      @partner = Partner.including_deleted.find(params[:id])
    else
      @partner = Partner.find(params[:id])
    end
  end

end