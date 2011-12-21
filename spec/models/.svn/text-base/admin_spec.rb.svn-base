require 'spec_helper'

describe Admin do
	
	before(:each) do
		@admin1 = Factory.build(:admin)
		@admin2 = Factory.build(:admin)
	end
	
	it { @admin1.should be_valid }
		
  it "has unique email" do
		@admin2.login_id = @admin1.login_id
		@admin2.should_not be_valid
  end
  
  it "name must be present" do	
  	@admin1.name = nil
  	@admin1.should_not be_valid
  	@admin2.should be_valid
  end
  
end
