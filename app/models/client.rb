# encoding: utf-8
class Client < ActiveRecord::Base
  ################
  #### Constants
  REGISTRATION_STATUSES = %w(仮登録 承認 非承認).freeze
  
  default_scope :conditions => { :deleted => false }
  
  has_many :promotions
  has_many :publishes, :through => :promotions, :conditions => { "promotions.deleted" => false }
  has_many :dailies
  has_many :statistics
  has_many :asps
  has_many :client_monthlies
  has_many :account_managements
  has_many :admins, :through => :account_managements

  scope :partners_count_scope,lambda{|client|
    joins(:promotions => {:publishes => {:site => :partner}})
                             .where("promotions.deleted = 0")
                             .where("publishes.deleted = 0")
                             .where("sites.deleted = 0")
                             .where("partners.deleted = 0")
                             .where(["clients.id = ?", client.id])
                             .group("partners.id")
                             .select("COUNT(*)")
  }

  scope :partners_scope,lambda{|client|
    joins(:promotions => {:publishes => {:site => :partner}})
                             .where("promotions.deleted = 0")
                             .where("publishes.deleted = 0")
                             .where("sites.deleted = 0")
                             .where("partners.deleted = 0")
                             .where(["clients.id = ?", client.id])
                             .select("DISTINCT partners.*")
  }

  devise :database_authenticatable,
         :trackable,
         :lockable,
         :timeoutable,
         :recoverable,
         :validatable,
         :registerable

  ###############      
  #### Validation
  devise    :validatable
  validates :consigned, :inclusion => { :in => [true, false] }
  validates :registration_status, :inclusion => { :in => 0..REGISTRATION_STATUSES.size }
  validates :site_name, :presence => true
  validates :site_url, :presence => true, :format => URI.regexp(['http', 'https'])
  validates :company_name, :presence => true
  validates :company_name_kana, :presence => true, :format => {:with => /^[ァ-ヴー]*$/, :message => I18n.t("activerecord.errors.messages.katakana")}
  validates :contractor_department, :presence => true
  validates :contractor_position, :presence => true
  validates :contractor_name, :presence => true
  validates :contractor_name_kana, :presence => true, :format => {:with => /^[ァ-ヴー]*$/, :message => I18n.t("activerecord.errors.messages.katakana")}
  validates :manager_department, :presence => true
  validates :manager_position, :presence => true
  validates :manager_name, :presence => true
  validates :manager_name_kana, :presence => true, :format => {:with => /^[ァ-ヴー]*$/, :message => I18n.t("activerecord.errors.messages.katakana")}
  validates :postal_code, :presence => true, :format => { :with => /[0-9]{3}-[0-9]{4}/i }
  validates :address, :presence => true
  validates :tel, :presence => true, :format => { :with => /^+{0,1}[\d]{0,4}-{0,1}[\d]{1,5}-[\d]{2,4}-[\d]{4}$/ }
  validates :login_id, :length => { :in => 1..254 }, :uniqueness => true
  
  # Make login_id accessible
  attr_accessible :login_id

  # Protect from mass-assignment  
  attr_protected :deleted, :registration_status, :consigned

  scope :approved, where( :registration_status => REGISTRATION_STATUSES.index("承認") )
  scope :partner_count, 
  # Override Reader
  def registration_status
    super
  end
  
  # Use this when find admin including deleted.
  # example:
  #   Admin.exclusive_scope.find(3)  
  def self.including_deleted
    with_exclusive_scope do
      self.scoped
    end
  end

  def approved?
    self.registration_status == REGISTRATION_STATUSES.index("承認")
  end
  
  def approve!
    self.registration_status = REGISTRATION_STATUSES.index("承認")
    self.save
  end

  def rejected?
    self.registration_status == REGISTRATION_STATUSES.index("非承認")
  end
  
  def reject!
    self.registration_status = REGISTRATION_STATUSES.index("非承認")
    self.save
  end

  def interimed?
    self.registration_status == REGISTRATION_STATUSES.index("仮登録")
  end
  
  def interim!
    self.registration_status = REGISTRATION_STATUSES.index("仮登録")
    self.save
  end

  def active_for_authentication?
    super && approved?
  end
  
  def partners_count
    client = Client.partners_count_scope self

    return client.all.count
  end
  
  def partners
    Client.partners_scope self
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
