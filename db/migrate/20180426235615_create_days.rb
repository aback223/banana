class CreateDays < ActiveRecord::Migration[5.0]
  def change
    create_table :days do |t|
      t.string :date
      t.string :rent
      t.belongs_to :listing
    end
  end
end
