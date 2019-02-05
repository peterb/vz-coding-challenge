class AddDebitAndCreditToEmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :emissions, :credit, :float
    add_column :emissions, :debit, :float
  end
end
