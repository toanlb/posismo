require 'spec_helper'

describe Admin::AdminController do
	
	def mock_admin
		@mock_admin ||= mock_model(Admin)
	end

	describe "GET #index" do
		describe "when admin did not login" do
			it "requires login" do
				get :index
				response.should redirect_to(new_admin_session_path)
			end
		end
		
		describe "when admin logged in" do
			login_admin
			it "response should be success" do
				get :index
				response.should be_success
			end
		end
		
	end
	
	describe "GET #show" do
		describe "when admin did not login" do
			it "requires login" do
				get :show
				response.should redirect_to(new_admin_session_path)
			end
		end
		
		describe "when admin logged in" do
			login_admin
			it "response should be success" do
				get :show
				response.should be_success
				response.should render_template({:controller => "admin/admins", :action => :show})
			end
			
			it "assigns a currently logged in admin as @admin" do
        get :show
        assigns(:admin).should eq(@current_admin)
      end
		end
		
	end
	
	describe "GET #edit" do
		describe "when admin did not login" do
			it "requires login" do
				get :edit
				response.should redirect_to(new_admin_session_path)
			end
		end

		describe "when admin logged in" do
			login_admin
			it "response should be success" do
				get :edit
				response.should be_success
				response.should render_template({ :controller => "admin/admins", :action => "edit" })
			end
			it "assigns a currently logged in admin as @admin" do
        get :edit
        assigns(:admin).should eq(@current_admin)
      end

		end
	end
	
	describe "POST #confirm" do
		describe "when admin did not login" do
			it "requires login" do
				post :confirm, :admin => { "something" => "nice" }
				response.should redirect_to(new_admin_session_path)
			end
		end
		
		describe "when admin logged in" do
			login_admin
			describe "with valid params" do
	      it "render confirmation template" do
					mock_admin.stub!(:valid?).and_return true
					Admin.stub(:new).with({ "name" => "new admin name" }) { mock_admin }
					
					post :confirm, :admin => { "name" => "new admin name" }
					
					assigns(:admin).should eq(mock_admin)
					response.should be_success
					response.should render_template({:controller => "admin/admins", :action => "confirm"})
	      end
	      
	    end
	
			describe "with invalid params" do
				it "render edit form again" do
  				mock_admin.stub(:valid?).and_return false
					Admin.stub(:new).with({ "name" => "bad name" }) { mock_admin }
					
					post :confirm, :admin => { :name => "bad name" }
					
					assigns(:admin).should eq(mock_admin)
					response.should be_success
					response.should render_template({:controller => "admin/admins", :action => "edit"})
	      end
			end
			
		end
	end
	
	describe "PUT #update" do
		describe "when admin did not login" do
			it "requires login" do
				post :update, :admin => { "something" => "nice" }
				response.should redirect_to(new_admin_session_path)
			end
		end

		describe "when admin logged in" do
			login_admin
			describe "with valid params" do
	      it "should assign current admin as @admin" do
	        put :update, :admin => {'name' => 'new name'}
	        assigns(:admin).should eq(@current_admin)
	      end

	      it "redirects to #show" do
	      	mock_admin.stub!(:update_attributes).with({'name' => 'new name'}).and_return(true)
	        
	        put :update, :admin => {'name' => 'new name'}
	        
	        assigns(:admin).should eq(@current_admin)
	        response.should redirect_to({ :action => :show })
	      end
	    end

	    describe "with invalid params" do
	      it "assigns the admin as @admin" do
	      	mock_admin.stub!(:update_attributes).with({'name' => 'new name'}).and_return(true)
	        
	        put :update, :admin => {'name' => 'new name'}
	        assigns(:admin).should eq(@current_admin)
	      end
	
	      it "re-renders the 'edit' template" do
	      	mock_admin.stub!(:update_attributes).with({'name' => 'new name'}).and_return(false)
	        
	        put :update, :admin => {'name' => 'new name'}
	        response.should render_template({:controller => "admin/admins", :action => "edit"})
	      end
	    end
		end
	end
end
