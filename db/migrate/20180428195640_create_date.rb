class CreateDate < ActiveRecord::Migration[5.0]
  def change
    create_table :dates do |t|
      t.string :date
      t.string :source_id
    end
  end
end
