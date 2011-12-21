require "spec_helper"

describe Client::ClientController do
  describe "routing" do
  	
		it "recognizes and generates #index" do
      { :get => "/client" }.should route_to(:controller => "client/client", :action => "index")
      { :get => client_root_path }.should route_to(:controller => "client/client", :action => "index")
    end
    it "recognizes and generates #show" do
      { :get => "/client/client" }.should route_to(:controller => "client/client", :action => "show")
    end
    it "recognizes and generates #edit" do
      { :get => "/client/client/edit" }.should route_to(:controller => "client/client", :action => "edit")
    end
    it "recognizes and generates #update" do
      { :put => "/client/client" }.should route_to(:controller => "client/client", :action => "update")
    end
    
  end
end
