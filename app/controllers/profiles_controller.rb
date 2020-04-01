class ProfilesController < ApplicationController
	before_action :authenticate_employee!

	def all_employees
      @emps = Employee.all.includes(:profile)
    end
end