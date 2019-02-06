# Atmospheric CO2 is a liability, so crediting it increases
# and debiting decreases it.
class Emission < ApplicationRecord
  belongs_to :sector
  belongs_to :territory
  belongs_to :period

  validate :conformity_of_entry

  class << self
    def filter(territory_code)
      world = Territory.where(code: territory_code).first
      from_world = world.emissions
      from_world_in_1850 = from_world.select { |emission| emission.period.year == 1850 }
      results = from_world_in_1850.inject(0){|running_total, emission| running_total += emission.retrieve_tonnage }
    end
  end

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
