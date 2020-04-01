class PostedShift < ActiveRecord::Base
  belongs_to :shift
  belongs_to :shif_for_trades, :source => "ShiftForTrades"
end
