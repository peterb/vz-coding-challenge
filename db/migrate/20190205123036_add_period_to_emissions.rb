class AddPeriodToEmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :emissions, :period_id, :integer
  end
end
