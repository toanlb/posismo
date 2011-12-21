# encoding: utf-8
class Notice < ActiveRecord::Base
  
  TARGETS = %w(広告主 パートナー 広告主、パートナー).freeze
  
  validates :target, :inclusion => { :in => TARGETS }
  
  scope :for_client, where("target in (?)", [TARGETS.index("広告主"),TARGETS.index("広告主、パートナー")])
  scope :for_partner, where("target in (?)", [TARGETS.index("パートナー"),TARGETS.index("広告主、パートナー")])
  
  def target
    read_attribute(:target).nil? ? nil : TARGETS[read_attribute(:target)]
  end
  
  def target=(data)
    write_attribute(:target, TARGETS.index(data))
  end
  
end
