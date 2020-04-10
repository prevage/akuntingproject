
class CreateBidLines < ActiveRecord::Migration
  def change
    create_table :bid_lines do |t|
      t.json :lines

      t.timestamps null: false
    end
  end
end