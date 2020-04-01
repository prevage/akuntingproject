module ApplicationHelper
	def title(page_title)
  		content_for :title, page_title.to_s
	end

  def profile
    if current_employee
      current_employee.profile
    end
  end

  def can_remove(emp_id)

  end

	def avatar_url(user)
    	default_url = "http://www.gravatar.com/avatar/HASH"
    	gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    	"http://gravatar.com/avatar/#{gravatar_id}.png?s=200{CGI.escape(default_url)}"
  	end

  	def flash_level(level)
	    case level.to_sym
	    when :notice then "alert-info"
	    when :error then "alert-error"
	    when :alert then "alert-danger fade in"
	   	when :warning then "alert-warning fade in"
	    when :success then "alert-success fade in"
	    end
  	end

  	def controller_assets
  		controller = params[:controller]
  		
  		if Rails.application.config.x.controller_with_assets.include? controller
  			javascript_include_tag("#{controller}/#{controller}", 'data-turbolinks-track' => true)  + stylesheet_link_tag(controller, 'data-turbolinks-track' => true)
  		end
  	end

end
