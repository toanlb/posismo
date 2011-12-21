# encoding: utf-8
module Twopm
	module Models
		module UserAccount
			
			def self.include(base)
				base.class_eval do
					mattr_accessor :registration_statuses
					@@registration_statuses = %w(仮登録 承認 非承認).freeze
		      
		      scope :approved, where( :registration_status => @@registration_statuses.index("承認") )
		      # Protect from mass-assignment  
			  	attr_protected :deleted, :registration_status
			  	
			  	
			  	extend ClassMethods
		    end
			end
				
			module ClassMethods
				
				
				# Override Reader
			  
			  # Use this when find admin including deleted.
				# example:
				# 	Admin.exclusive_scope.find(3)	
				def self.including_deleted
					with_exclusive_scope do
						self.scoped
					end
				end
			end	
				
			def registration_status.to_s
				registration_statuses[read_attribute(:registration_status)]
			end
			
			def approved?
		  	self.registration_status == "承認"
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
	end
end	
