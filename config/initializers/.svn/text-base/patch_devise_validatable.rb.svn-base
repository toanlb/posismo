####
# Deviseがemailをuniquenessとしているため、uniqunessを外す修正するパッチ
# Deviseのバージョンアップにより修正される可能性がある。
# Hyungjin KIM 2011/06/02

module Devise::Models::Validatable
  def self.included(base)
    base.extend ClassMethods
    assert_validations_api!(base)

    base.class_eval do
      validates_presence_of   :email
      validates_format_of     :email, :with  => email_regexp, :allow_blank => true, :if => :email_changed?


      with_options :if => :password_required? do |v|
        v.validates_presence_of     :password
        v.validates_presence_of     :password_confirmation
        v.validates_confirmation_of :password
        v.validates_length_of       :password, :within => password_length, :allow_blank => true
      end
    end
  end
end

