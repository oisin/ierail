require 'simplecov'
require 'coveralls'
require 'tzinfo'
require 'vcr'
require 'timecop'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start
