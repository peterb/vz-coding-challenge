# Since data isn't in production yet, this migration only changes
# the database schema.
class RemoveTonnageFromEmissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :emissions, :tonnage, :float
  end
end
