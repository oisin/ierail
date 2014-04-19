require 'date'

Gem::Specification.new do |s|
  s.name        = 'ierail'
  s.version     = '0.4.0'
  s.date        = Date.today.to_s
  s.summary     = "Irish Rail Train Schedule and Status API"
  s.description = "Irish Rail Train Schedule and Status API"
  s.authors     = ["Oisin Hurley", "Gary Rafferty", "Michael Dever"]
  s.email       = 'oi.sin@nis.io'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'http://rubygems.org/gems/ierail'
  s.add_runtime_dependency 'json', '~> 1.8', '>= 1.8.1'
  s.add_runtime_dependency 'rest-client', '~> 1.6', '>= 1.6.7'
  s.add_runtime_dependency 'nokogiri', '~> 1.6', '>= 1.6.1'
  s.add_runtime_dependency 'tzinfo', '~> 1.1', '>= 1.1.0'
  s.add_development_dependency 'vcr', '~> 2.9.0'
  s.add_development_dependency 'webmock', '~> 1.17.4'
  s.add_development_dependency 'timecop', '~> 0.6.2'
end
