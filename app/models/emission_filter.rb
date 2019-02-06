class EmissionFilter
  attr_accessor :territory_code
  attr_accessor :year
  attr_accessor :sector_name

  def results
    if @year.present?
      from_territory_in(@year)
    elsif @territory_code.present?
      from_territory
    elsif @sector_name.present?
      from_sector
    end
  end

  def total
    if @year.present?
      sum_tonnage(from_territory_in(@year))
    elsif @territory_code.present?
      sum_tonnage(from_territory)
    elsif @sector_name.present?
      sum_tonnage(from_sector)
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

    def sector
      Sector.where(name: @sector_name).first
    # Sector.where("lower(name) = ?", @sector_name.downcase).first
    end

    def from_sector
      sector.emissions
    end
end