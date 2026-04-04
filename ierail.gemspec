require 'date'

Gem::Specification.new do |s|
  s.name        = 'ierail'
  s.version     = '0.5.0'
  s.date        = Date.today.to_s
  s.summary     = "Irish Rail Train Schedule and Status API"
  s.description = "Irish Rail Train Schedule and Status API"
  s.authors     = ["Oisin Hurley", "Gary Rafferty", "Michael Dever"]
  s.email       = 'oisin.hurley@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'http://rubygems.org/gems/ierail'
  s.licenses    = ["BSD 2-Clause 'Simplified' License"]
  s.required_ruby_version = ">=3.3.0"
  s.add_runtime_dependency 'json', "~> 2", ">= 2.12.2"
  s.add_runtime_dependency 'rest-client', "~> 2", ">= 2.1.0"
  s.add_runtime_dependency 'nokogiri', "~> 1", ">= 1.18.8"
  s.add_runtime_dependency 'tzinfo', "~> 2", ">= 2.0.6"
  s.add_development_dependency 'vcr', "~> 6", ">= 6.3.1"
  s.add_development_dependency 'webmock', "~> 3", ">= 3.25.1"
  s.add_development_dependency 'timecop', "~> 0", ">= 0.9.10"
  s.add_development_dependency 'minitest', "~> 5", ">= 5.25.5"
end
