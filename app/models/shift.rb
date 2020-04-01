class Shift < ActiveRecord::Base
  MIN_TIME = "00:00"
  MAX_TIME = "23:59" 
  belongs_to :profile, :inverse_of => :shifts, dependent: :destroy

  has_many :trade_with_collegues, class_name: "CollegueTrade", :foreign_key => "post_id"

    def calendar_start_time
        start.change(day: date.day, month: date.month, year: date.year)
    end
    
    def calendar_end_time
        finish.change(day: date.day, month: date.month, year: date.year)
    end
    
    
    def overlaps?(shift)
        (start_time - shift.finish_time) * (shift.start_time - finish_time) > 0
    end
    
    def post!
        self.update_attributes!(:posted =