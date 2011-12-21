require "spec_helper"

describe Admin::ClientsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/clients" }.should route_to(:controller => "admin/clients", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/clients/new" }.should route_to(:controller => "admin/clients", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/clients/1" }.should route_to(:controller => "admin/clients", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/clients/1/edit" }.should route_to(:controller => "admin/clients", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/clients" }.should route_to(:controller => "admin/clients", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/clients/1" }.should route_to(:controller => "admin/clients", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/clients/1" }.should route_to(:controller => "admin/clients", :action => "destroy", :id => "1")
    end

  end
end
