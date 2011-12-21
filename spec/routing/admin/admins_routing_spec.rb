require "spec_helper"

describe Admin::AdminController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/admins" }.should route_to(:controller => "admin/admins", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/admins/1" }.should route_to(:controller => "admin/admins", :action => "show", :id => "1")
    end
		
		it "recognizes and generates #new" do
      { :get => "/admin/admins/new" }.should route_to(:controller => "admin/admins", :action => "new")
    end
    
    it "recognizes and generates #create" do
      { :post => "/admin/admins" }.should route_to(:controller => "admin/admins", :action => "create")
    end
    
    it "recognizes and generates #edit" do
      { :get => "/admin/admins/1/edit" }.should route_to(:controller => "admin/admins", :action => "edit", :id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/admins/1" }.should route_to(:controller => "admin/admins", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/admins/1" }.should route_to(:controller => "admin/admins", :action => "destroy", :id => "1")
    end

  end
end
