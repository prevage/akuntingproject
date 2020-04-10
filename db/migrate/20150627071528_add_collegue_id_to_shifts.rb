
class AddCollegueIdToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :collegue_id, :integer, :default => false
  end
end