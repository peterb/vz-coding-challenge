class EmissionFilter
  attr_accessor :territory_code
  attr_accessor :year

  def results
    if @year.present?
      from_territory_in(@year)
    else
      from_territory
    end
  end

  def total
    if @year.present?
      sum_tonnage(from_territory_in(@year))
    else
      sum_tonnage(from_territory)
    end
  end

  private

    def sum_tonnage(emissions)
      emissions.inject(0){|running_total, emission| running_total += emission.retrieve_tonnage }
    end

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