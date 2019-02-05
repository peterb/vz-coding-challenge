# Atmospheric CO2 is a liability, so crediting it increases
# and debiting decreases it.
class Emission < ApplicationRecord
  belongs_to :sector
  belongs_to :territory
  belongs_to :period

  validate :conformity_of_entry

  def retrieve_tonnage
    if credit.present?
      credit
    elsif debit.present?
      debit * -1
    end
  end

  private

  def conformity_of_entry
    if is_ambiguous?
      errors.add(:debit, "there is also a credit.")
      errors.add(:credit, "there is also a debit.")
    end
  end

  def is_ambiguous?
    credit.present? && debit.present?
  end
end
