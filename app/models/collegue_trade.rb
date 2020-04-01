class CollegueTrade < Shift
	belongs_to :collegue, class_name: 'Profile', foreign_key: 'collegue_id'
end