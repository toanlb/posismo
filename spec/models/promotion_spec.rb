require 'spec_helper'

describe Promotion do
  it "could be activated if it has only one basic reward" do
    promotion = Promotion.make!(:reward => Reward.make!(3, :basic_fixed));
    promotion.shoule be_valid
  end
  it "could not be activated if it has only one basic reward"
end
