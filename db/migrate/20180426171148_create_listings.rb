class CreateListings < ActiveRecord::Migration[5.0]
  def change
    create_table :listings do |t|
      t.string :unit_number
      t.string :unit_type
      t.string :sq_feet
      t.string :rent_cost
      t.string :availability
      t.string :source
    end
  end
end
