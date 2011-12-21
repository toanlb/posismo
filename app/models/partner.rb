# encoding: utf-8
class Partner < ActiveRecord::Base

  ################
  #### Constants
  REGISTRATION_STATUSES = %w(仮登録 承認 非承認).freeze
  CONTRACT_TYPES = %w(法人 個人).freeze
  MEDIA_TYPES = %w(Webサイト メールマガジン).freeze
  PAYMENT_TYPES = %w(銀行 ゆうちょ銀行 請求書送付).freeze

  default_scope :conditions => { :deleted => false }

  has_many :sites, :dependent => :destroy
  has_many :publishes, :through => :sites, :conditions => { "sites.deleted" => false }
#  has_many :promotions, :through => :publishes, :conditions => { "publishes.deleted" => false }
  has_many :dailies
  has_many :partner_monthlies
  has_many :statistics

  devise  :database_authenticatable,
          :trackable,
          :lockable,
          :timeoutable,
          :recoverable,
          :validatable,
          :registerable

  validates :registration_status, :inclusion => { :in => 0..REGISTRATION_STATUSES.size }
  validates :contract_type, :inclusion => { :in => 0..CONTRACT_TYPES.size }
  validates :payment_type, :inclusion => { :in => 0..PAYMENT_TYPES.size }
  validates :postal_code, :format => { :with => /[0-9]{3}-[0-9]{4}/i }, :unless => Proc.new{|partner| partner.postal_code.blank? }
  validates :login_id, :length => { :in => 1..254 }, :uniqueness => true
  validates :tel, :format => { :with => /^+{0,1}[\d]{0,4}-{0,1}[\d]{1,5}-[\d]{2,4}-[\d]{4}$/, :if => Proc.new{ |partner| partner.tel.present? }}
  validates :company_name_kana, :format => {:with => /^[ァ-ヴー]*$/, :message => I18n.t("activerecord.errors.messages.katakana")}, :if => Proc.new{|partner| partner.company_name_kana.present? }
  validates :contractor_name_kana, :format => {:with => /^[ァ-ヴー]*$/, :message => I18n.t("activerecord.errors.messages.katakana")}, :if => Proc.new{|partner| partner.contractor_name_kana.present? }
  validates :manager_name_kana, :format => {:with => /^[ァ-ヴー]*$/, :message => I18n.t("activerecord.errors.messages.katakana")}, :if => Proc.new{|partner| partner.manager_name_kana.present? }

  scope :approved, where( :registration_status => REGISTRATION_STATUSES.index("承認") )

  scope :clients_count_scope,lambda{|partner|
    joins(:sites => {:publishes => {:promotion => :client}})
                                            .where("sites.deleted = 0")
                                            .where("publishes.deleted = 0")
                                            .where("promotions.deleted = 0")
                                            .where("clients.deleted = 0")
                                            .where(["partners.id = ?", partner.id])
                                            .group("clients.id")
                                            .select("COUNT(*)")
  }

  scope :clients_scope,lambda{|partner|
    joins(:sites => {:publishes => {:promotion => :client}})
                                            .where("sites.deleted = 0")
                                            .where("publishes.deleted = 0")
                                            .where("promotions.deleted = 0")
                                            .where("clients.deleted = 0")
                                            .where(["partners.id = ?", partner.id])
                                            .select("DISTINCT clients.*")
  }
  
  scope :promotions_scope,lambda{|partner|
    joins(:sites => {:publishes => :promotion})
                                            .where("sites.deleted = 0")
                                            .where("publishes.deleted = 0")
                                            .where("promotions.deleted = 0")
                                            .where(["partners.id = ?", partner.id])
                                            .select("DISTINCT promotions.*")
  }
  
  # nested attributes
  accepts_nested_attributes_for :sites
  # Make login_id accessible
  attr_accessible :login_id
  # Protect from mass-assignment  
  attr_protected :deleted, :registration_status

  def self.including_deleted
    with_exclusive_scope do
      self.scoped
    end
  end

  def self.find_including_deleted(partner_id)
    with_exclusive_scope do
      where(:id => partner_id)
    end
  end
  
  # def self.find_duplicate?(partner_id)
    # !Partner.where(:id => partner_id).blank?
  # end

  def find_duplicate?
    !Partner.where(:id => self.id).blank?
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

  def clients_count
    partner = Partner.clients_count_scope self

    return partner.all.count
  end

  def clients
    Partner.clients_scope self
  end
  
  def promotions
    Partner.promotions_scope self
  end
  
  # def no_tel_validate(boolean)
    # @no_tel_validate = boolean
  # end
#   
  # def no_tel_validate?
    # @no_tel_validate
  # end

protected
  #####
  # 登録情報変更フォームでパスワードを空欄のままにしても更新できるように
  # Deviseをoverride
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

end
