
class ShiftsController < ApplicationController
  before_action :authenticate_employee!
  respond_to :json, :html
  def index
  	@user = current_employee.profile
  	@shifts = @user.shifts.where(:scheduled => "IN", :type => nil)

  	respond_with(@shifts) 
  end

  def show
  	@user = current_employee.profile
  	@shift = @user.shifts.where(:id => params[:id])
  	respond_with(@shift)
  end
end