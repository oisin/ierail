$:.unshift(File.join(File.dirname(__FILE__), '..','..', 'lib'))

require 'minitest/autorun'
require 'ierail'

class StationTest < MiniTest::Unit::TestCase
  def setup
    ir = IERail.new
    @station = ir.stations.sample #Use a random station
  end

  def test_that_a_station_has_a_description
    refute_empty @station.description
  end

  def test_that_a_station_responds_to_name_alias
    assert_respond_to @station, :name
    assert_equal @station.name, @station.description
  end

  def test_that_a_station_has_a_location
    refute_empty @station.location
  end

  def test_that_a_stations_locations_is_an_array
    assert_equal @station.location.class, Array
  end

  def test_that_a_stations_location_contains_two_values
    assert_equal @station.location.size, 2
  end

  def test_that_a_station_has_a_code
    refute_empty @station.code
  end

  def test_that_a_stations_has_an_id
    refute_empty @station.id
  end
end

