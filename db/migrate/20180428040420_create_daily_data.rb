class CreateDailyData < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_data do |t|
      t.string :date
      t.string :occupancy
      t.string :leased
    end
  end
end
