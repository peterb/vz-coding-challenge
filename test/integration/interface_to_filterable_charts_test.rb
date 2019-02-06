require 'test_helper'

class InterfaceToFilterableChartsTest < ActionDispatch::IntegrationTest
  test "Emissions can be filtered by territories such as the whole world." do
    results = Emission.filter('WORLD')
    assert(results == 2050.0)
  end
end
