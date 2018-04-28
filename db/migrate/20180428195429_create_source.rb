class CreateSource < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|
      t.string :name
    end
  end
end
