
class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :fname
      t.string :lname
      t.integer :bid_line
      t.references :employee, index: true, foreign_key: true
      t.integer :emp_num

      t.timestamps null: false
    end
  end
end