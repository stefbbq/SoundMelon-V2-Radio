class Users::SessionsController < Devise::SessionsController

	def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
		redirect_to root_path
	end

end