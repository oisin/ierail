$:.unshift(File.join(File.dirname(__FILE__), '..','..', 'lib'))

require 'minitest/autorun'
require 'ierail'

class IERailTest < MiniTest::Unit::TestCase
  def setup
    @ir = IERail.new
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
    thirty_mins = Time.now + 60*30
    time = "#{thirty_mins.hour}:#{thirty_mins.min}" # "HH:MM"
    before_train = @ir.southbound_from('Malahide').before(time).sample
    assert Time.parse(before_train.expdepart) <= thirty_mins
  end

  def test_that_the_after_time_constraint_works
    #Thirty minutes from now
    thirty_mins = Time.now + 60*30
    time = "#{thirty_mins.hour}:#{thirty_mins.min}" # "HH:MM"
    after_train = @ir.southbound_from('Malahide').after(time).sample
    assert Time.parse(after_train.expdepart) >= thirty_mins
  end
end
