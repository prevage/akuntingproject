class ProfileAccountController < Devise::RegistrationsController
  before_action :authenticate_employee!
  require 'pry'
  require 'calendar_setup'

    def after_sign_up_path_for(resource)
    	profile_path(resource)
    end

  	def edit
  	end

  	def update
      if params[:employee][:profile_attributes][:bid_line].nil?
        super
      else
        super    
        if resource.save
          start_date = BidLine.first.lines.symbolize_keys[:day_1].to_date
          line_number = params[:employee][:profile_attributes][:bid_line].to_s
          line = BidLine.where("lines->>'line_number' = ?", line_number).first.lines.deep_symbolize_keys!
          calendar = Calendar::Calendar.new(start_date, line, profile)
          calendar.build
        end
      end
  	end
    
    protected
    
    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    def after_update_path_for(resource)
      profile_path(resource)
    end

    

  	private 

end
