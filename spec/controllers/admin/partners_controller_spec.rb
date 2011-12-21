require 'spec_helper'

describe Admin::PartnersController do
	def mock_partner
		@mock_partner ||= mock_model(Partner)
	end
	
	describe "when did not login as admin" do
		
	end
	
	describe "when admin logged in" do
	
	end
	
	#index
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
				response.should render_template( :action => :index )
			end
		end
		
	end
	
	#show
	describe "GET #show" do
		describe "when admin did not login" do
			it "requires login" do
				get :show, :id => "1096"
				response.should redirect_to(new_admin_session_path)
			end
		end
		
		describe "when admin logged in" do
			login_admin
			it "response should be success" do
				Partner.stub!(:find_by_id).with(1096).and_return(mock_partner)
				
				get :show, :id => 1096
				
				assigns(:admin).should eq(mock_partner)
				response.should be_success
				response.should render_template( :action => :show )
			end
		end
		
	end
	
	#edit
	describe "GET #edit" do
		describe "when admin did not login" do
			it "requires login" do
				get :edit, :id => 1096
				response.should redirect_to(new_admin_session_path)
			end
		end
		
		describe "when admin logged in" do
			login_admin
			it "response should be success" do
				Partner.stub!(:find_by_id).with(1096).and_return(mock_partner)
				get :edit, :id => 1096
				response.should be_success
				assigns(:admin).should eq(mock_partner)
				response.should render_template( :action => :edit )
			end
		end
	end
	
	#confirm	
	describe "POST #confirm" do
		describe "when admin did not login" do
			it "requires login" do
				post :confirm, :id => 1096, :partner => { "something" => "nice" }
				response.should redirect_to(new_admin_session_path)
			end
		end
		
		describe "when admin logged in" do
			login_admin
			it "response should be success" do
				Partner.stub!(:find_by_id).with(1096).and_return(mock_partner)
				mock_partner.stub!(:attributes=).with({ "name" => "new name" }).and_return(mock_partner)
				
				post :confirm, :id => 1096, :partner => { "name" => "new name" }
				
				response.should be_success
				assigns(:admin).should eq(mock_partner)
			end
			
			describe "with valid params" do
	      it "render confirmation template" do
	      	Partner.stub!(:find_by_id).with(1096).and_return(mock_partner)
					mock_partner.stub!(:attributes=).with({ "name" => "new name" }).and_return(mock_partner)
	      	mock_partner.stub!(:valid?).and_return true
					
					post :confirm, :id => 1096, :partner => { "name" => "new name" }
					
					assigns(:admin).should eq(mock_partner)
					response.should be_success
					response.should render_template({:controller => "admin/admins", :action => "confirm"})
	      end
	      
	    end
	
			describe "with invalid params" do
				it "render edit form again" do
					Partner.stub!(:find_by_id).with(1096).and_return(mock_partner)
					mock_partner.stub!(:attributes=).with({ "name" => "bad name" }).and_return(mock_partner)
  				mock_partner.stub(:valid?).and_return false					
					
					post :confirm, :id => 1096, :partner => { :name => "bad name" }
					
					assigns(:admin).should eq(mock_partner)
					response.should be_success
					response.should render_template({:controller => "admin/admins", :action => "edit"})
	      end
			end
		end

	end
	
	#update
	describe "PUT #update" do
		describe "when admin did not login" do
			it "requires login" do
				post :update, :id => 1096, :partner => { "name" => "new name" }
				response.should redirect_to(new_admin_session_path)
			end
		end

		describe "when admin logged in" do
			login_admin
			describe "with valid params" do
	      it "should assign current admin as @admin" do
	      	Partner.stub!(:find_by_id).with(1096).and_return(mock_partner)
	      	mock_partner.stub!(:update_attributes).with({ "name" => "new name" }).and_return(mock_partner)
	      	
	        put :update, :id => 1096, :partner => { "name" => "new name" }
	        
	        assigns(:admin).should eq(mock_partner)
	      end

	      it "redirects to #show" do
	      	Partner.stub!(:find_by_id).with(1096).and_return(mock_partner)
	      	mock_partner.stub!(:update_attributes).with({ "name" => "new name" }).and_return(true)
	        
	        put :update, :id => 1096, :partner => { "name" => "new name" }
	        
	        assigns(:admin).should eq(mock_partner)
	        response.should redirect_to({ :action => :show, :id => 1096 })
	      end
	    end

	    describe "with invalid params" do
	      it "assigns the partner as @partner" do
	      	Partner.stub!(:find_by_id).with(1096).and_return(mock_partner)
	      	mock_partner.stub!(:update_attributes).with({ "name" => "new name" }).and_return(true)
	        
	        put :update, :id => 1096, :partner => { "name" => "new name" }
	        assigns(:admin).should eq(mock_partner)
	      end
	
	      it "re-renders the 'edit' template" do
	      	Partner.stub!(:find_by_id).with(1096).and_return(mock_partner)
	      	mock_partner.stub!(:update_attributes).with({ "name" => "new name" }).and_return(false)
	        
	        put :update, :id => 1096, :partner => { "name" => "new name" }
	        response.should render_template({ :action => "edit" })
	      end
	    end
		end
	end
	
	describe "DELETE destroy" do
		describe "when admin did not login" do
			it "requires login" do
				delete :destroy, :id => 1096
				response.should redirect_to(new_admin_session_path)
			end
		end

		describe "when admin logged in" do
			login_admin
			it "requires super admin authorization" do
				delete :destroy, :id => 1096
				response.should redirect_to(admin_root_path)
			end
		end
		
		describe "when super admin logged in" do
			login_super_admin
			it "destroys the requested admin" do
	      Admin.should_receive(:find_by_id).with(1096) { mock_partner }
	      mock_partner.should_receive(:deleted=).with(true)
	      mock_partner.should_receive(:save)
	      
	      delete :destroy, :id => 1096
	    end
	  
	    it "redirects to the admins list" do
	      Admin.should_receive(:find_by_id).with(1096) { mock_partner }
	      mock_partner.should_receive(:deleted=).with(true)
	      mock_partner.should_receive(:save)
	      
	      delete :destroy, :id => 1096
	      response.should redirect_to(:action => :index)
	    end
	  end
  end

end
