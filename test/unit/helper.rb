require 'simplecov'
require 'coveralls'
require 'tzinfo'
require 'vcr'
require 'timecop'
require 'minitest/autorun'
require 'ierail'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start
