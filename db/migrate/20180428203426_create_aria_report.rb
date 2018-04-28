class CreateAriaReport < ActiveRecord::Migration[5.0]
  def change
    create_table :aria_reports do |t|
      t.string :floorplan
      t.integer :vacant
      t.decimal :vacant_pct
      t.integer :avail
      t.decimal :avail_pct
      t.integer :exposure
      t.decimal :exp_pct
      t.integer :min
      t.integer :max
      t.integer :avg
      t.integer :date_id
    end
  end
end
