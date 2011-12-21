class AccountManagement < ActiveRecord::Base
  belongs_to :client
  belongs_to :admin
  
end
