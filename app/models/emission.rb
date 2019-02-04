class Emission < ApplicationRecord
	belongs_to :sector
	belongs_to :territory
	belongs_to :year

	def retrieve_tonnage
	  tonnage
	end

	private
end
