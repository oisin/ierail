$:.unshift(File.join(File.dirname(__FILE__), '..','..', 'lib'))

require_relative 'helper'

require 'minitest/autorun'
require 'ierail'
require 'tzinfo'

class IERailTest < MiniTest::Unit::TestCase
  def setup
    @ir = IERail.new

    @now = Time.now

    if TZInfo::Timezone.get('Europe/Dublin').current_period.dst?
      unless @now.zone == 'IST'
        @now -= @now.utc_offset - 3600
      end
    else
      @now -= @now.utc_offset
    end
  end

  def test_that_the_train_directions_are_correct
    northbound_train = @ir.northbound_from('Dublin Connolly').sample
    southbound_train = @ir.southbound_from('Dublin Connolly').sample
    assert_equal northbound_train.direction, 'Northbound'
    assert_equal southbound_train.direction, 'Southbound'
  end

  def test_that_an_empty_array_is_returned_when_no_data
    nonexistant = @ir.westbound_from('Clongriffin')
    assert_empty nonexistant
  end

  def test_that_the_before_time_constraint_works
    #Thirty minutes from now
    thirty_mins = @now + (60 * 30)
    time = "#{thirty_mins.hour}:#{thirty_mins.min}" # "HH:MM"
    before_train = @ir.southbound_from('Dublin Connolly').before(time).sample
    assert before_train.arrival[:expected] <= thirty_mins
  end

  def test_that_the_after_time_constraint_works
    #Thirty minutes from now
    thirty_mins = @now + (60 * 30)
    time = "#{thirty_mins.hour}:#{thirty_mins.min}" # "HH:MM"
    after_train = @ir.southbound_from('Dublin Connolly').after(time).sample
    assert after_train.arrival[:expected] >= thirty_mins
  end

  def test_that_the_in_constraint_works
    mins = 30
    thirty_mins = @now + (60 * mins)
    time = "#{thirty_mins.hour}:#{thirty_mins.min}" # "HH:MM"

    before_train = @ir.southbound_from('Malahide').before(time)
    in_half_an_hour = @ir.southbound_from('Malahide').in(mins)

    assert_equal before_train.count, in_half_an_hour.count
    before_train_codes = before_train.map {|t| t.train_code}
    half_hour_train_codes = in_half_an_hour.map {|t| t.train_code}
    assert_equal before_train_codes, half_hour_train_codes
  end

  def test_that_station_times_returns_station_data
    train = @ir.station_times('Dublin Connolly', 30).sample #random train in next 30 mins
    assert_equal train.class, StationData #StationData has already been tested
  end

  def test_that_station_times_equivalent_to_in
    trains = @ir.station_times('Dublin Connolly', 30)
    in_half_an_hour = @ir.station('Dublin Connolly').in(30)

    assert_equal trains.count, in_half_an_hour.count
    trains_codes = trains.map {|t| t.train_code}
    half_hour_train_codes = in_half_an_hour.map {|t| t.train_code}
    assert_equal trains_codes, half_hour_train_codes
  end

  def test_that_found_station_is_a_struct_with_name_description_code
    station = @ir.find_station('con').sample
    assert_equal station.class, Struct::Station
    refute_nil station.name
    refute_nil station.description
    refute_nil station.code
  end
end
