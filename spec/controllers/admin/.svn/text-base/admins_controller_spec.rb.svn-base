require 'spec_helper'

describe Admin::AdminsController do
	def mock_admin
		@mock_admin ||= Factory.create(:admin)
	end

	####
	describe "When did not logged in as admin" do
		describe "All Action" do
			it "Should redirecto to admin login page" do
				get :index
				response.should redirect_to(new_admin_session_path)
				get :show, :id => "1096"
				response.should redirect_to(new_admin_session_path)
				get :new
				response.should redirect_to(new_admin_session_path)
				post :create
				response.should redirect_to(new_admin_session_path)
				get :edit, :id => 1096
				response.should redirect_to(new_admin_session_path)
				put :update, :id => 1096
				response.should redirect_to(new_admin_session_path)
				delete :destroy, :id => 1096
				response.should redirect_to(new_admin_session_path)
			end
		end
	end
	####
	describe "When logged in as normal admin" do
		login_admin
		describe "All Action" do
			it "Should redirecto to admin top page" do
				get :index
				response.should redirect_to(admin_root_path)
				get :show, :id => "1096"
				response.should redirect_to(admin_root_path)
				get :new
				response.should redirect_to(admin_root_path)
				post :create
				response.should redirect_to(admin_root_path)
				get :edit, :id => 1096
				response.should redirect_to(admin_root_path)
				put :update, :id => 1096
				response.should redirect_to(admin_root_path)
				delete :destroy, :id => 1096
				response.should redirect_to(admin_root_path)
			end
		end
	end
	####
	describe "When logged in as super admin" do
		login_super_admin

		describe "GET #index" do
			it "Response should be success and render template" do
				get :index
				response.should be_success
				response.should render_template( :action => :index )
			end
		end
		describe "GET #show" do
			it "Assigns the admin as @admin" do
				get :show, :id => mock_admin.id
				assigns(:admin).should eq(mock_admin)
			end
			it "Response should be success and render template" do
				get :show, :id => mock_admin.id
				response.should be_success
				response.should render_template( :action => :show )
			end
		end
		describe "GET #new" do
			it "Assigns new admin as @admin" do
				new_admin = Admin.new
				Admin.stub!(:new) { new_admin }
				get :new
				assigns(:admin).should eq(new_admin)
			end
			it "Response should be success and render template" do
				response.should be_success
				response.should render_template( :action => :new )
			end
		end
		describe "POST #create" do
			it "Assigns the admin as @admin" do
				new_admin = Factory.build(:admin)
				Admin.stub!(:new) { new_admin }
				post :create, :admin => new_admin.attributes
				assigns(:admin).should eq(new_admin)
			end
			describe "Before confirmation" do
				describe "With invalid params" do
					it "Should re-render #edit template" do
						new_admin = Factory.build(:admin)
						Admin.stub!(:new) { new_admin }
						new_admin.stub!(:valid?).and_return false
						post :create, :admin => new_admin.attributes
						response.should render_template( :action => :new )
					end
				end
				describe "With valid params" do
					it "Should render template #create" do
						mock_admin.stub!(:valid?).and_return true
						post :create, :admin => { "name" => "new name" }
						response.should redirect_to( :action => :create )
					end
				end
			end
			describe "After confimation" do
				describe "With invalid params" do
					it "Re-renders #new' template" do
						mock_admin.stub!(:valid?).and_return false
						post :create, :admin => { "name" => "new name" }
						response.should render_template( :action => :new )
					end
				end
				describe "With valid params" do
					it "Redirects to #show" do
						mock_admin.stub!(:valid?).and_return true
						post :create, :admin => { "name" => "new name" }
						response.should redirect_to( :action => :show, :id => mock_admin.id )
					end
				end
			end
		end
		describe "GET #edit" do
			it "Assigns the admin as @admin" do
				get :edit, :id => mock_admin.id
				assigns(:admin).should eq(mock_admin)
			end
			it "Response should be success and render template" do
				response.should be_success
				response.should render_template( :action => :edit )
			end
		end
		describe "PUT #update" do
			it "Assigns the admin as @admin" do
				put :update, :id => mock_admin.id, :admin => { "name" => "new name" }
				assigns(:admin).should eq(mock_admin)
			end
			describe "Before confirmation" do
				describe "With invalid params" do
					it "Should re-render #edit template" do
						mock_admin.stub!(:valid?).and_return false
						put :update, :id => mock_admin.id, :admin => { "name" => "new name" }
						response.should render_template( :action => :edit )
					end
				end
				describe "With valid params" do
					it "Should render template #update" do
						mock_admin.stub!(:valid?).and_return true
						put :update, :id => mock_admin.id, :admin => { "name" => "new name" }
						response.should redirect_to( :action => :update )
					end
				end
			end
			describe "After confimation" do
				describe "With invalid params" do
					it "Re-renders the 'edit' template" do
						mock_admin.stub!(:valid?).and_return false
						put :update, :id => mock_admin.id, :admin => { "name" => "new name" }
						response.should render_template( :action => :edit )
					end
				end
				describe "With valid params" do
					it "Redirects to #show" do
						mock_admin.stub!(:valid?).and_return true
						put :update, :id => mock_admin.id, :admin => { "name" => "new name" }
						response.should redirect_to( :action => :show, :id => mock_admin.id )
					end
				end
			end
		end
		describe "DELETE #destroy" do
			it "destroys the requested admin" do
				Admin.should_receive(:find_by_id).with(1096) { mock_admin }
				mock_admin.should_receive(:deleted=).with(true)
				mock_admin.should_receive(:save)

				delete :destroy, :id => 1096
			end

			it "redirects to the admins list" do
				Admin.should_receive(:find_by_id).with(1096) { mock_admin }
				mock_admin.should_receive(:deleted=).with(true)
				mock_admin.should_receive(:save)

				delete :destroy, :id => 1096
				response.should redirect_to(:action => :index)
			end
		end
	end

end
