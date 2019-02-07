require 'test_helper'

class TerritoryTest < ActiveSupport::TestCase
  test "Territory codes are unique." do
    territory = Territory.new
    territory.code = "ABW"
    assert !territory.save
  end
end
