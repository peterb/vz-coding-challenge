class CreateSectors < ActiveRecord::Migration[5.2]
  def change
    create_table :sectors do |t|
      t.string :name
      t.integer :sector_id

      t.timestamps
    end
  end
end
