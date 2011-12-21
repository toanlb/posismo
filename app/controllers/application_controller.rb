# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  # NOTE: Not needed in rails 3.1
  include ::SslRequirement

  protect_from_forgery

  layout :layout_by_resource

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from RuntimeError, :with => :routing_error

#  protected
  # Set layout for devise
  def layout_by_resource
    if devise_controller?
      resource_name.to_s
    else
      default_layout
    end
  end

  def current_scope
    @_current_scope ||= request.path.split('/')[1]
  end

  def current_scope?(scope)
    current_scope == scope
  end

#  private
  def record_not_found
    render :file => "public/404.html", :status => 404
  end

  def routing_error
    render :nothing => true
    @admins = find_admins_for_notification
    subject = "Routing Error"
    content = <<-STRING
      Request: #{request.server_name}:#{request.server_port}#{request.fullpath}
      Referer: #{request.env['HTTP_REFERER']}
      RemoteIP: #{request.remote_ip}
    STRING
    @admins.each do |admin|
      #AdminNotifier.notify_error(admin, subject, content).deliver
    end
    redirect_to root_path if Rails.env == 'production'
  end

  def default_layout

  end

  # viewに広告主業務中であることを知らせるために宣言する。
  # viewではApplication_helper#consigned_work?で確認する。
  def declare_consigned_work!
    @consigned_work = true
  end

  def find_admins_for_notification
    if Rails.env.production?
      Admin.where(:super_user => true)
    else
      Admin.order("id ASC").limit(2)
    end
  end

  def after_sign_out_path_for(resource)
    resource.to_s == "admin" ? root_path : new_session_path(resource)
  end
  
  def signed_in_root_path(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    home_path = "#{scope}_root_path"
    respond_to?(home_path, true) ? send(home_path) : root_path
  end
  
  def stored_location_for(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    if session["#{scope}_return_to"].to_s == "/#{scope}/login"
      session.delete("#{scope}_return_to")
      return signed_in_root_path(resource_or_scope)
    else
      session.delete("#{scope}_return_to")
    end
  end
  
end
