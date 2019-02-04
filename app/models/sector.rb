class Sector < ApplicationRecord
  belongs_to :sector, optional: true

  def mother
  	sector
  end

  def grandmother
  	return sector.sector if sector.present? && sector.sector.present?
  end

  private
end
