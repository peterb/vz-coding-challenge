require 'test_helper'

class InterfaceToFilterableChartsTest < ActionDispatch::IntegrationTest
  test "Emissions can be filtered by territories such as the whole world." do
    world = territories(:world)
    from_world = world.emissions
    from_world_in_1850 = from_world.select { |emission| emission.period.year == 1850 }
    results = from_world_in_1850.inject(0){|running_total, emission| running_total += emission.retrieve_tonnage }
    assert(results == 2050.0)
  end
end
