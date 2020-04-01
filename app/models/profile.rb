class Profile < ActiveRecord::Base
  belongs_to :employee
  has_many :shifts, dependent: :destroy
  has_many :date_availables
  has_many :posts
  has_many :posted_shifts, class_name: "ShiftForTrade"
  has_many :trade_requests, class_name: "CollegueTrade", foreign_key: "collegue_id"
  has_many :pending_requests, class_name: "CollegueTrade"
  validates :bid_line, numericality: true, :allow_nil => true
  validate :line_exist, unless: 'bid_line.nil?'

  def line_exist
  	unless BidLine.where("lines->>'line_number' = ?", bid_line.to_s).exists?
  		 errors.add(:bid_line, "This is not a valid bid line #")
  	end
  end

  def available?(trade_shift)
  	shift = self.shifts.where(date: trade_shift.date).first
    	if !shift.nil?
        	if shift.overlaps?(trade_shift)
                return false
            else
                return true
            end
        else 
            return true
        end
  end
  
end
