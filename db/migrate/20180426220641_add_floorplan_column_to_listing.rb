class AddFloorplanColumnToListing < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :floorplan, :string
  end
end
