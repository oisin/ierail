$:.unshift(File.join(File.dirname(__FILE__), '..','..', 'lib'))

require_relative 'helper'

class TrainTest < Minitest::Test
  def setup
    ir = IERail.new

    VCR.configure do |c|
      c.cassette_library_dir = 'fixtures/vcr_cassettes'
      c.hook_into :webmock
    end

    VCR.use_cassette('trains') do
      @train = ir.trains.sample #Use a random station
    end
  end

  def test_that_a_train_has_status
    refute_empty @train.status
  end

  def test_that_a_train_has_a_location
    refute_empty @train.location
  end

  def test_that_a_trains_location_is_an_array
    assert_equal @train.location.class, Array
  end

  def test_that_the_location_array_contains_only_two_values
    assert_equal @train.location.size, 2
  end

  def test_that_a_train_has_a_code
    refute_empty @train.code
  end

  def test_that_a_train_has_a_date
    refute_nil @train.date
  end

  def test_that_a_train_has_a_message
    refute_empty @train.message
  end

  def test_that_a_train_has_a_direction
    refute_empty @train.direction
  end

end
