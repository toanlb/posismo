require "spec_helper"

describe Admin::AdminController do
  describe "routing" do

  	it "recognizes and generates #index" do
      { :get => "/admin" }.should route_to(:controller => "admin/admin", :action => "index")
      { :get => admin_root_path }.should route_to(:controller => "admin/admin", :action => "index")
    end
    it "recognizes and generates #show" do
    	{ :get => "/admin/admin" }.should route_to(:controller => "admin/admin", :action => "show")
    end
    it "recognizes and generates #edit" do
    	{ :get => "/admin/admin/edit" }.should route_to(:controller => "admin/admin", :action => "edit")
    end
    it "recognizes and generates #confirm" do
    	{ :post => "/admin/admin/confirm" }.should route_to(:controller => "admin/admin", :action => "confirm")
    end
    it "recognizes and generates #update" do
    	{ :put => "/admin/admin" }.should route_to(:controller => "admin/admin", :action => "update")
    end
    
  end
end
