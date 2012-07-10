$:.unshift(File.join(File.dirname(__FILE__), '..','..', 'lib'))

require 'minitest/autorun'
require 'ierail'

class IERailTest < MiniTest::Unit::TestCase
  def setup
    ir = IERail.new
    @northbound_train = ir.northbound_from('Howth Junction').sample
    @southbound_train = ir.southbound_from('Clongriffin').sample
    @nonexistant      = ir.westbound_from('Clongriffin')
  end

  def test_that_the_train_directions_are_correct
    assert_equal @northbound_train.direction, 'Northbound'
    assert_equal @southbound_train.direction, 'Southbound'
  end

  def test_that_an_empty_array_is_returned_when_no_data
    assert_empty @nonexistant
  end
end
