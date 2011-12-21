class Site < ActiveRecord::Base
  include ActiveModel::Dirty
  
  default_scope :conditions => { :deleted => false }
  scope :belong_to_client, lambda{|client|
    joins(:publishes => :promotion).
      where(["promotions.client_id = ?", client.id])
  }

  belongs_to :partner
  has_many :publishes
  has_many :promotions, :through => :publishes
  has_many :categories_sites
  has_many :categories, :through => :categories_sites
  has_many :dailies, :through => :publishes

  # nested attributes
  accepts_nested_attributes_for :partner

  validates :name, :presence => true
  validates :url, :presence => true, :format => URI.regexp(['http', 'https'])
  validates :description, :presence => true
  validates :keywords, :presence => true

  def find_duplicate?
    !!!Site.where(:id => self.id).blank?
  end
  
  def check_related_publishes
    if self.deleted_changed?
      self.publishes.each do |publish|
        if self.deleted == true
          publish.deleted = true
          publish.save
        else if self.deleted == false
            publish.deleted = false
            publish.save
          end
        end
      end
    end
  end
  
end
