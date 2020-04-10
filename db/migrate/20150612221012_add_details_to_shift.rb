
class AddDetailsToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :description, :text
    add_column :shifts, :original_owner, :integer
    add_column :shifts, :posted, :boolean, :null => false, :default => false
    add_column :shifts, :partial, :boolean, :null => false, :default => false
    add_column :shifts, :available, :boolean, :null => false, :default => false
    add_column :shifts, :period_available, :string, :default => false
    add_column :shifts, :type, :string
    add_column :shifts, :post_id, :integer, :default => false
  end
end