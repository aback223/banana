class CreateAriaStaticData < ActiveRecord::Migration[5.0]
  def change
    create_table :aria_static_data do |t|
      t.string :floorplan
      t.integer :total
      t.integer :source_id
    end
  end
end