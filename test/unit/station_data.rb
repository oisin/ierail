$:.unshift(File.join(File.dirname(__FILE__), '..','..', 'lib'))

require_relative 'helper'

class StationDataTest < MiniTest::Unit::TestCase
  def setup
    ir = IERail.new
    
    VCR.configure do |c|
      c.cassette_library_dir = 'fixtures/vcr_cassettes'
      c.hook_into :webmock
    end

    VCR.use_cassette('station') do
      @station_data = ir.station('Dublin Connolly').sample #Use a random station
    end
  end

  def test_that_there_is_a_traincode
    refute_empty @station_data.traincode
  end

  def test_that_there_is_a_station_name_and_code
    refute_empty @station_data.name
    refute_empty @station_data.code
  end

  def test_that_there_is_a_status
    refute_empty @station_data.status
  end

  def test_that_there_is_a_due_value
   refute_empty @station_data.due_in
  end

  def test_that_there_is_a_late_value
    refute_empty @station_data.late
  end

  def test_that_there_is_a_query_time
    refute_nil @station_data.query_time
  end

  def test_that_there_is_a_train_date
    refute_empty @station_data.train_date
  end

  def test_that_origin_method_returns_a_hash
    assert_equal @station_data.origin.class, Hash
  end  
  
  def test_that_there_is_an_origin_name_and_time
    refute_empty @station_data.origin[:name]
    refute_nil @station_data.origin[:time]
  end

  def test_that_destination_method_returns_a_hash
    assert_equal @station_data.destination.class, Hash
  end

  def test_that_there_is_a_destination_name_and_time
    refute_empty @station_data.destination[:name]
    refute_nil @station_data.destination[:time]
  end

  def test_that_arrival_method_returns_a_hash
    assert_equal @station_data.arrival.class, Hash
  end

  def test_that_there_is_an_arrival_sched_and_exp
    refute_nil @station_data.arrival[:scheduled]
    refute_nil @station_data.arrival[:expected]
  end

  def test_that_departure_method_returns_a_hash
    assert_equal @station_data.departure.class, Hash
  end

  def test_that_there_is_a_departure_sched_and_exp
    refute_nil @station_data.departure[:scheduled]
    refute_nil @station_data.departure[:expected]
  end

  def test_that_it_responds_to_late?
    assert_respond_to @station_data, :late? 
  end

  def test_late_method
    if @station_data.late.to_i > 0
      assert @station_data.late?
    else
      refute @station_data.late?
    end
  end
end 
