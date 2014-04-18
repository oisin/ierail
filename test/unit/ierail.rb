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
    northbound_train = @ir.northbound_from('Howth Junction').sample
    southbound_train = @ir.southbound_from('Clongriffin').sample
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
    assert before_train.expdepart <= thirty_mins
  end

  def test_that_the_after_time_constraint_works
    #Thirty minutes from now
    thirty_mins = @now + (60 * 30)
    time = "#{thirty_mins.hour}:#{thirty_mins.min}" # "HH:MM"
    after_train = @ir.southbound_from('Dublin Connolly').after(time).sample
    assert after_train.expdepart >= thirty_mins
  end

  def test_that_the_in_constraint_works
    mins = 30
    thirty_mins = @now + (60 * mins)
    time = "#{thirty_mins.hour}:#{thirty_mins.min}" # "HH:MM"
    before_train = @ir.southbound_from('Malahide').before(time)

    in_half_an_hour = @ir.southbound_from('Malahide').in(mins)
    assert_equal before_train.count, in_half_an_hour.count
    before_train.each_with_index { |b,i|
      assert_equal b.traincode, in_half_an_hour[i].traincode
    }
  end

  def test_station_times
    station_data = @ir.station_times('Dublin Connolly',30).sample
    assert_instance_of StationData, station_data
  end

  def test_find_station
    station = @ir.find_station('Howth').sample
    assert_instance_of Struct::Station, station
  end
end
