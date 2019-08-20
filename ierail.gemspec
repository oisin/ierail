require 'date'

Gem::Specification.new do |s|
  s.name        = 'ierail'
  s.version     = '0.4.2'
  s.date        = Date.today.to_s
  s.summary     = "Irish Rail Train Schedule and Status API"
  s.description = "Irish Rail Train Schedule and Status API"
  s.authors     = ["Oisin Hurley", "Gary Rafferty", "Michael Dever"]
  s.email       = 'oi.sin@nis.io'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'http://rubygems.org/gems/ierail'
  s.add_runtime_dependency 'json', "~> 2", ">= 2.2.0"
  s.add_runtime_dependency 'rest-client', "~> 2", ">= 2.0.2"
  s.add_runtime_dependency 'nokogiri', "~> 1", ">= 1.10.4"
  s.add_runtime_dependency 'tzinfo', "~> 2", ">= 2.0.0"
  s.add_development_dependency 'vcr', "~> 5", ">= 5.0.0"
  s.add_development_dependency 'webmock', "~> 3", ">= 3.6.2"
  s.add_development_dependency 'timecop', "~> 0", ">= 0.9.1"
  s.add_development_dependency 'minitest', "~> 5", ">= 5.11.3"
end
