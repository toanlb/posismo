require "spec_helper"

describe Partner::PartnerController do
	describe "routing" do
  	
		it "recognizes and generates #index" do
      { :get => "/partner" }.should route_to(:controller => "partner/partner", :action => "index")
      { :get => partner_root_path }.should route_to(:controller => "partner/partner", :action => "index")
    end
    it "recognizes and generates #new" do
      { :get => "/partner/partner/new" }.should route_to(:controller => "partner/partner", :action => "new")
    end
    it "recognizes and generates #show" do
      { :get => "/partner/partner" }.should route_to(:controller => "partner/partner", :action => "show")
    end
    it "recognizes and generates #edit" do
      { :get => "/partner/partner/edit" }.should route_to(:controller => "partner/partner", :action => "edit")
    end
    it "recognizes and generates #update" do
      { :put => "/partner/partner" }.should route_to(:controller => "partner/partner", :action => "update")
    end
    
  end
end
