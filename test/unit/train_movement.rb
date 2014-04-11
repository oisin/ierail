$:.unshift(File.join(File.dirname(__FILE__), '..','..', 'lib'))

require_relative 'helper'

require 'minitest/autorun'
require 'ierail'

class TrainMovementTest < MiniTest::Unit::TestCase
  def setup
    ir = IERail.new
        
    train_code = ir.trains.sample.code #Use a random train code
    @train_movement = ir.train_movements(train_code).sample #Use a random movement from the random train
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
end 
