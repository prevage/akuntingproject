class ShiftForTrade < Shift
	before_destroy :remove_profile_id
	belongs_to :original_shift, class_name: "Shift", foreign_key: :post_id
	def remove_profile_id
		self.update_attributes!(:profile_id => nil)
	end
end