module DashboardsHelper

	def work_today?(task)
		if task.scheduled == "IN"
			return true
		elsif task.scheduled == "OFF"
			return false
		else
			return false
		end
	end

  def can_remove(emp_id)
  	profile.id.to_s.eql?(emp_id)
  end

end
