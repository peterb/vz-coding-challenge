require 'test_helper'

class EmissionTest < ActiveSupport::TestCase
  test "Emissions exist." do  	
    assert(Emission.where(credit: 0.0419).present?)
  end

  test "Emissions can be either credited or debited but not both." do
    emission = emissions(:one)
    emission.credit = 0.412
    emission.debit = 0.412
    assert(!emission.save)
  end
end
