require 'test_helper'

class InterfaceToFilterableChartsTest < ActionDispatch::IntegrationTest
  test "Emissions can be filtered by territories such as the whole world." do
    filter = EmissionFilter.new
    filter.territory_code = 'WORLD'
    assert(filter.results == 2050.0)
  end

  test "Emissions can be filtered by territories, by year." do
    filter = EmissionFilter.new
    filter.territory_code = 'WORLD'
    filter.year = 1850
    assert(filter.results == 2050.0)
  end

  test "Emissions can be filtered by territories, by a year that isn't in the data." do
    filter = EmissionFilter.new
    filter.territory_code = 'WORLD'
    filter.year = 1851
    assert(filter.results == 0.0)
  end
end
