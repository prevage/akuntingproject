class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :profile


    def profile
      if current_employee
        current_employee.profile
      end
    end

    def after_sign_in_path_for(resource)
      dashboard_path
    end

    protected

    def configure_permitted_parameters
    	devise_parameter_sanitizer.for(:account_update) {|u| u.permit(
		    :email,
		    :password,
		    :password_confirmation,
		    :current_password,
		    profile_attributes: [:fname, :lname, :bid_line, :id]
  		)}
    end

    private 
end
