
class TradeCenterController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_remove_shift, only: [:pick_up_shift,:cancel_shift]
  before_action :set_shift, only: [:pick_up_shift,:post_shift, :trade_with_collegue]
  before_action :set_original_shift, only: [:pick_up_shift]


  respond_to :html, :json, :js
  def all_posted_shifts
  	@posted_shifts = ShiftForTrade.all
  end


  def all_availability
  end

  def trade_requests
    @trade_requests = profile.trade_requests
  end

  def pending_requests
    @pending_requests = profile.pending_requests
  end

  def available_on_date
    #@available = Shift.where(:date => params[:date]) 
    @users = Shift.where(:date => params[:date], :available => true)
    respond_with(@users)
  end

  def user_availability
  end

  def set_user_availability
    @date_available = Array.new
    @user = current_employee.profile
    @availability = params[:availability][:dates].split(",")
    @availability.each do |date|
        shift = @user.shifts.where(:date => date).first
        shift.available = true
        @date_available << shift
    end

    Shift.transaction do
      @date_available.each(&:save!)
    end

    redirect_to availability_path
  end

  
  def post_shift
    if @shift.posted
      redirect_to :back, :flash => { :warning => "This shift is already on the board!" }
    end
  end

  def submit_shift
    @shift = Shift.find(params[:shift][:original_id])
    start = Time.parse(params[:shift][:start_time])
    finish = Time.parse(params[:shift][:finish_time])
    
    dup_shift = set_shift_for_post(@shift, start, finish) 

    if (dup_shift.is_partial?(@shift))
      dup_shift.partial = true
    end
    
    if params[:shift][:collegue_id]
      dup_shift.collegue_id = params[:shift][:collegue_id]
      post_shift = CollegueTrade.new(dup_shift.attributes.except("type"))
    else
      post_shift = ShiftForTrade.new(dup_shift.attributes.except("type"))
    end

    if post_shift.save && @shift.post!
      shiftForPick = ShiftForTrade.count
      WebsocketRails[:trades].trigger('new_trade_post', {pickUpShifts: shiftForPick})
      flash[:success] = "Shift successfully Posted."
      redirect_to posted_shifts_path
    else
      flash[:alert] = 'Could not post your shift on Trade Board!'
      redirect_to @shift
    end

  end

  def pick_up_shift  # Needs major refactoring but will concentrate on it later need to see it work first!
    @posted_shift = @shift
    if profile.available?(@posted_shift)
        # If @shift does not equal to @original_shift than shift is split
        # else shift is similar swap record's profile_id 
        if @posted_shift.partial
          if !@original_shift.start_time.eql?(@posted_shift.start_time)
            temp = @original_shift.finish_time.change(hour: @posted_shift.start_time.hour, min: @posted_shift.start_time.min)
            @original_shift.finish_time = temp

          elsif !@original_shift.finish_time.eql?(@posted_shift.finish_time)
            temp = @original_shift.start_time.change(hour: @posted_shift.finish_time.hour, min: @posted_shift.finish_time.min)
            @original_shift.start_time = temp
          end
          
          @posted_shift.profile_id = profile.id
          @posted_shift.type = nil

        else
          @original_shift.profile_id = profile.id
          @posted_shift.destroy
        end
        
        if @posted_shift.partial
          if @posted_shift.save && @original_shift.save
            flash[:success] = 'Shift successfully traded.' 
            redirect_to calendar_path
          else
            flash[:alert] = "Shift Could not be Traded"
            redirect_to posted_shifts_path
          end
        else 
          if @original_shift.save
            flash[:success] = 'Shift successfully traded.' 
            redirect_to calendar_path
          else
            flash[:alert] = "Shift Could not be Traded"
            redirect_to posted_shifts_path
          end
        end

    else
        flash[:alert] = "You are already scheduled on that day."
        redirect_to posted_shifts_path
    end
    
  end

  def trade_with_collegue
  end

  def cancel_shift
    flash[:success] = 'Shift successfully removed from board.' if @posted_shift.destroy && @shift.unpost!
    shiftForPick = ShiftForTrade.count
    WebsocketRails[:trades].trigger('new_trade_post', {pickUpShifts: shiftForPick})
    redirect_to posted_shifts_path
  end


  private

  def post_shift_params
    params.require(:shift).permit(:position, :date, :start_time, :finish_time, :description, :scheduled, :profile_id, :post_id, :available, :collegue_id)
  end

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def set_remove_shift
    @posted_shift = ShiftForTrade.find(params[:id])
    @shift = @posted_shift.original_shift
  end

  def set_original_shift
    @original_shift = Shift.find(@shift.post_id)
  end
  # Maybe put in different
  def set_shift_for_post(shift, start, finish)
      dup = shift.dup
      temp_start = dup.start_time.change(hour: start.hour, min: start.min)
      temp_finish = dup.finish_time.change(hour: finish.hour, min: finish.min)
      dup.start_time = temp_start
      dup.finish_time = temp_finish
      dup.post_id = shift.id
      dup.profile_id = profile.id

      dup
  end

end