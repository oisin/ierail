$:.unshift(File.join(File.dirname(__FILE__), '..','..', 'lib'))

require_relative 'helper'

class TrainMovementTest < Minitest::Test
  def setup
    ir = IERail.new

    VCR.configure do |c|
      c.cassette_library_dir = 'fixtures/vcr_cassettes'
      c.hook_into :webmock
    end

    VCR.use_cassette('trains') do
      @train_code = ir.trains.first.code #Use a random train code

      VCR.use_cassette('train_movements') do
       # The hard-code of the Time here is to match the VCR cassette
       # for this API call - otherwise we re-create all the fixtures,
       # all the time, electrons squandered, early heat-death of
       # universe ensues, exuent omnes, persued by entropy.
       sample_t = Time.new(2014, 4, 19)
       @train_movement = ir.train_movements(@train_code, sample_t).sample #Use a random movement from the random train
      end
    end
  end

  def test_that_location_method_returns_a_hash
    assert_equal @train_movement.location.class, Hash
  end

  def test_that_there_is_a_location_code_and_name_and_stop_number_and_type
    refute_empty @train_movement.location[:code]
    refute_empty @train_movement.location[:name]
    refute_nil @train_movement.location[:stop_number]
    refute_empty @train_movement.location[:type]
  end

  def test_that_arrival_method_returns_a_hash
    assert_equal @train_movement.arrival.class, Hash
  end

  def test_that_there_is_an_arrival_sched_and_exp_and_actual
    refute_nil @train_movement.arrival[:scheduled]
    refute_nil @train_movement.arrival[:expected]
    refute_nil @train_movement.arrival[:actual]
  end

  def test_that_departure_method_returns_a_hash
    assert_equal @train_movement.departure.class, Hash
  end

  def test_that_there_is_a_departure_sched_and_exp_and_actual
    refute_nil @train_movement.departure[:scheduled]
    refute_nil @train_movement.departure[:expected]
    refute_nil @train_movement.departure[:actual]
  end

  def test_that_it_responds_to_station
    assert_respond_to @train_movement, :station
  end

  def test_that_train_method_returns_a_hash
    assert_equal @train_movement.train.class, Hash
  end

  def test_that_there_is_a_train_code_date_and_origin
    refute_nil @train_movement.train[:code]
    refute_nil @train_movement.train[:date]
    refute_nil @train_movement.train[:origin]
  end
end
