# encoding: utf-8
class Publish < ActiveRecord::Base
  belongs_to :promotion
  belongs_to :site
  has_many :orders
  belongs_to :asp
  has_one :partner, :through => :site
  
  APPROVAL_STATUSES = %w(承認待ち 承認 非承認 保留).freeze
  SEARCH_APPROVAL_STATUSES = { "全て" => "",
    "承認待ち" => 0,
    "承認" => 1
    }.freeze
    
  default_scope :conditions => { :deleted => false }
  
  def approval_status
    APPROVAL_STATUSES[read_attribute(:approval_status)]
  end
  def approval_status=(data)
    write_attribute(:approval_status, APPROVAL_STATUSES.index(data))
  end
  
  attr_protected :approval_status
  
  def approved?
    self.approval_status == "承認"
  end
  
  def approve!
    self.approval_status = "承認"
    self.save
  end
  
  def rejected?
    self.approval_status == "非承認"
  end
  
  def reject!
    self.approval_status = "非承認"
    self.save
  end
  
  def defer?
    self.approval_status == "保留"
  end
  
  def defer!
    self.approval_status = "保留"
    self.save
  end
  
  def handled?
     approved? || rejected?
  end
  
  scope :approved, where(:approval_status => "承認")
  
end
