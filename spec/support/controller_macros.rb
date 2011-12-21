module ControllerMacros
	def login(mapping, as = nil)
		before(:each) do
			@request.env["devise.mapping"] = mapping
			eval "@current_#{mapping} = as || Factory.create(mapping)"
			eval "sign_in @current_#{mapping}"
		end
	end

	def current_admin
		@current_admin
	end

	def login_admin( as = nil )
		login( :admin, as )
	end

	def login_super_admin( as = nil )
		login( :admin, as || Factory.create(:super_admin) )
	end

end
