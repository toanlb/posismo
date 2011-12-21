require 'spec_helper'

describe Reward do
  
  it "should be basic fixed price" do
    reward = Reward.make(:basic_fixed)
    reward.basic?.should be_true
    reward.fixed_price?.should be_true
  end
  
  it "should be basic rate price" do
    reward = Reward.make(:basic_rate)
    reward.basic?.should be_true
    reward.rate_price?.should be_true
  end
  
  it "should be campaign fixed price" do
    reward = Reward.make(:campaign_fixed)
    reward.campaign?.should be_true
    reward.fixed_price?.should be_true
  end
  
  it "should be campaign rate price" do
    reward = Reward.make(:campaign_rate)
    reward.campaign?.should be_true
    reward.rate_price?.should be_true
  end
  
  it "should be consigned basic fixed price" do
    reward = Reward.make(:basic_fixed_consigned)
    reward.basic?.should be_true
    reward.fixed_price?.should be_true
    reward.net_price.should_not be_nil
  end
  
  it "should be consigned basic rate price" do
    reward = Reward.make(:basic_rate_consigned)
    reward.basic?.should be_true
    reward.rate_price?.should be_true
    reward.net_rate.should_not be_nil
  end
  
  it "should be consigned campaign fixed price" do
    reward = Reward.make(:campaign_fixed_consigned)
    reward.campaign?.should be_true
    reward.fixed_price?.should be_true
    reward.net_price.should_not be_nil
  end
  
  it "should be consigned campaign rate price" do
    reward = Reward.make(:campaign_rate_consigned)
    reward.campaign?.should be_true
    reward.rate_price?.should be_true
    reward.net_rate.should_not be_nil
  end
  
  describe "campaign reward feature" do
    it "should have only one basic reward" do
      promotion = Promotion.make!
      Reward.make!(:basic_fixed, :promotion => promotion)
      reward = Reward.make(:basic_fixed)
      reward.promotion = promotion
      reward.should_not be_valid
    end
    
  end  
end
