class CreateEmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :emissions do |t|
      t.integer :territory_id
      t.integer :sector_id
      t.integer :year_id
      t.float :tonnage

      t.timestamps
    end
  end
end
