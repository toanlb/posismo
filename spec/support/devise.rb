RSpec.configure do |config|
  # include test helpers for devise.  
  config.include Devise::TestHelpers, :type => :controller
end
