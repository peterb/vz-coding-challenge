class Sector < ApplicationRecord
  belongs_to :sector, optional: true
  has_many :emissions

  def mother
    sector
  end

  def grandmother
    return sector.sector if grandmother_present?
  end

  private
    def grandmother_present?
      sector.present? && sector.sector.present?
    end
end
