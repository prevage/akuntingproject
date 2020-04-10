
class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.string :position
      t.date :date
      t.datetime :start_time
      t.datetime :finish_time
      t.string :scheduled
      t.references :profile, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end