class RemoveRentCostColumnFromListings < ActiveRecord::Migration[5.0]
  def change
    remove_column :listings, :rent_cost
  end
end
