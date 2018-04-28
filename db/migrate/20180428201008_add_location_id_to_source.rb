class AddLocationIdToSource < ActiveRecord::Migration[5.0]
  def change
    add_column :sources, :location_id, :integer
  end
end
