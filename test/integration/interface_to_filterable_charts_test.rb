require 'test_helper'

# Tests will have to be changed to reflect larger dataset
# when it's imported. Currently out by a factor of 10 i.e.
# 3.59e8 will have to be changed to 3.59e9.
class InterfaceToFilterableChartsTest < ActionDispatch::IntegrationTest
  test "Emissions can be filtered by territories such as planets." do
  	results = Territory.where(code: 'EARTH').years.where(name: '2014').emissions.sum(:retrieve_tonnage)
  	assert_not_nil(results)
  end

  test "Emissions can be filtered by territories such as federations of states." do
  	results = Territory.where(code:'EU28').years.where(name: '2014').emissions.sum(:retrieve_tonnage)
  	assert_not_nil(results)
  end

  test "Emissions can be filtered by territories such as countries." do
  	results = Territory.where(code:'IRL').years.where(name: '2014').emissions.sum(:retrieve_tonnage)
  	assert_not_nil(results)
  end

  test "Emissions can be filtered by territory and sector." do
  	results = Territory.where(code:'IRL').sectors.where(name: 'Mineral Products').emissions.sum(:retrieve_tonnage)
  	assert_not_nil(results)
  end

  test "Emissions can be filtered by territory, sector, and year." do
  	results = Territory.where(code:'IRL').years.where(name: '1982').sectors.where(name: 'Mineral Products').emissions.sum(:retrieve_tonnage)
  	assert_not_nil(results)
  end

  test "Emissions can be filtered by sector only" do
  	results = Sector.where(name: 'Agriculture').emissions.sum(:retrieve_tonnage)
  end

  test "Sectors have parent sectors." do
    assert(Sector.where(name: 'Fugitive Emissions from Oil and Gas').parent == Sector.where(name: 'Energy'))
    assert(Sector.where(name: 'Energy').parent == Sector.where(name: 'Total including LULUCF'))
  end

  test "Earth C02 emissions in tonnes for 2014 match www.co2.earth/global-co2-emissions." do
  	results = Territory.where(code: 'EARTH').years.where(name: '2014').emissions.sum(:retrieve_tonnage)
    assert_in_delta( 3.59e8, results, 0.5e8, explain_test_failure)
  end
  
  def explain_test_failure
  	"Expected total_co2_emissions for 2014 to be close to 3.59e10."
  end
end
