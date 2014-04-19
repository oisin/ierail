$:.unshift(File.join(File.dirname(__FILE__), '..','..', 'lib'))

require_relative 'helper'

class IERailTest < MiniTest::Unit::TestCase
  def setup
    @ir = IERail.new

    VCR.configure do |c|
      c.cassette_library_dir = 'fixtures/vcr_cassettes'
      c.hook_into :webmock
    end
  end

  def test_that_the_train_directions_are_correct
    VCR.use_cassette('northbound') do |cassette|
      Timecop.freeze(cassette.originally_recorded_at || Time.now) do
        northbound_train = @ir.northbound_from('Dublin Connolly').sample
        assert_equal northbound_train.direction, 'Northbound'
      end
    end
    VCR.use_cassette('northbound') do |cassette|
      Timecop.freeze(cassette.originally_recorded_at || Time.now) do
        southbound_train = @ir.southbound_from('Dublin Connolly').sample
        assert_equal southbound_train.direction, 'Southbound'
      end
    end
  end

  def test_that_an_empty_array_is_returned_when_no_data
    VCR.use_cassette('westbound') do |cassette|
      Timecop.freeze(cassette.originally_recorded_at || Time.now) do
        nonexistant = @ir.westbound_from('Clongriffin')
        assert_empty nonexistant
      end
    end
  end

  def test_that_the_before_time_constraint_works
    VCR.use_cassette('northbound') do |cassette|
      Timecop.freeze(cassette.originally_recorded_at || Time.now) do
        #Thirty minutes from now
        thirty_mins = Time.now + (60 * 30)
        time = "#{thirty_mins.hour}:#{thirty_mins.min}" # "HH:MM"
        before_train = @ir.southbound_from('Dublin Connolly').before(time).sample
        assert before_train.expdepart <= thirty_mins
      end
    end
  end

  def test_that_the_after_time_constraint_works
    VCR.use_cassette('southbound') do |cassette|
      Timecop.freeze(cassette.originally_recorded_at || Time.now) do
        #Thirty minutes from now
        thirty_mins = Time.now + (60 * 30)
        time = "#{thirty_mins.hour}:#{thirty_mins.min}" # "HH:MM"
        after_train = @ir.southbound_from('Dublin Connolly').after(time).sample
        assert after_train.expdepart >= thirty_mins
      end
    end
  end

  def test_that_the_in_constraint_works
    VCR.use_cassette('southbound_from') do |cassette|
      Timecop.freeze(cassette.originally_recorded_at || Time.now) do
        mins = 30
        thirty_mins = Time.now + (60 * mins)
        time = "#{thirty_mins.hour}:#{thirty_mins.min}" # "HH:MM"
        southbounds = @ir.southbound_from('Dublin Connolly')

        before_train = southbounds.before(time)

        in_half_an_hour = southbounds.in(mins)
        assert_equal before_train.count, in_half_an_hour.count
        before_train.each_with_index { |b,i|
          assert_equal b.traincode, in_half_an_hour[i].traincode
        }
      end
    end
  end

  def test_station_times
    VCR.use_cassette('station_times') do |cassette|
      Timecop.freeze(cassette.originally_recorded_at || Time.now) do
        station_data = @ir.station_times('Dublin Connolly',30).sample
        assert_instance_of StationData, station_data
      end
    end
  end

  def test_find_station
    VCR.use_cassette('find_station') do |cassette|
      Timecop.freeze(cassette.originally_recorded_at || Time.now) do
        station = @ir.find_station('Dublin Connolly').sample
        assert_instance_of Struct::Station, station
      end
    end
  end

  def test_that_station_times_returns_station_data
    VCR.use_cassette('station_times') do |cassette|
      Timecop.freeze(cassette.originally_recorded_at || Time.now) do
        train = @ir.station_times('Dublin Connolly', 30).sample #random train in next 30 mins
        assert_equal train.class, StationData #StationData has already been tested
      end
    end
  end

  def test_that_station_times_equivalent_to_in
    VCR.use_cassette('station_times') do |cassette|
      trains = @ir.station_times('Dublin Connolly', 30)
      
      VCR.use_cassette('station') do |cassette|
        in_half_an_hour = @ir.station('Dublin Connolly').in(30)

        assert_equal trains.count, in_half_an_hour.count
        trains_codes = trains.map {|t| t.traincode}
        half_hour_train_codes = in_half_an_hour.map {|t| t.traincode}
        assert_equal trains_codes, half_hour_train_codes
      end
    end
  end

  def test_that_found_station_is_a_struct_with_name_description_code
    VCR.use_cassette('find_station') do |cassette|
      station = @ir.find_station('Dublin Connolly').sample
      assert_equal station.class, Struct::Station
      refute_nil station.name
      refute_nil station.description
      refute_nil station.code
    end
  end
end
