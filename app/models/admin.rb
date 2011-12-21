# -*- coding: utf-8 -*-
class Admin < ActiveRecord::Base
  devise :trackable
  devise :lockable 
  devise :timeoutable
  devise :database_authenticatable
  devise :validatable

  validates :name, :presence => true, :length => { :within => 1..254, :allow_nil => false }
  validates :login_id, :length => { :in => 6..254 }, :uniqueness => true
  has_many :account_managements
  has_many :clients, :through => :account_managements
  
  # Make login_id accessible
  attr_accessible :login_id
  # Protect from mass-assignment  
  attr_protected :super_user
  attr_protected :deleted

  # Use dafault_scope
  default_scope :conditions => { :deleted => false }

  # Use this when find admin including deleted.
  # example:
  #   Admin.including_deleted.find(3)  
  def self.including_deleted
    with_exclusive_scope do
      self.scoped
    end
  end

  def super_user!
    self.super_user = true
    self.save(:validate => false)
  end

protected
  #####
  # 登録情報変更フォームでパスワードを空欄のままにしても更新できるように
  # Deviseをoverride
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

end
