class EmissionFilter
  attr_accessor :territory_code
  attr_accessor :year

  def results
    if @year.present?
      from_territory_in(@year).inject(0){|running_total, emission| running_total += emission.retrieve_tonnage }
    else
      from_territory.inject(0){|running_total, emission| running_total += emission.retrieve_tonnage }
    end
  end

  private

    def territory
      Territory.where(code: @territory_code).first
    end

    def from_territory
      territory.emissions
    end

    def from_territory_in(year)
      from_territory.select { |emission| emission.period.year == year }
    end
end