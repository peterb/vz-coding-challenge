class RemoveYearIdFromEmissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :emissions, :year_id, :integer
  end
end
