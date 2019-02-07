require 'test_helper'

class SectorTest < ActiveSupport::TestCase
  test "Sectors exist." do
    assert(Sector.where(name: 'Energy').present?)
  end

  test "Some sectors have one simple mother." do
    assert(Sector.where(name: 'Fugitive Emissions from Oil and Gas').first.mother == Sector.where(name: 'Energy').first)
  end

  test "Some sectors have one complex mother." do
    assert(Sector.where(name: 'Energy').first.mother == Sector.where(name: 'Total including LULUCF').first)
  end

  test "Some sectors have one grandmother." do
    assert(Sector.where(name: 'Fugitive Emissions from Oil and Gas').first.grandmother == Sector.where(name: 'Total including LULUCF').first)
  end

  test "Sector names are unique." do
    sector = Sector.new
    sector.name = "Energy"
    assert !sector.save
  end
end
