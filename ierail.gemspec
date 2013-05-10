Gem::Specification.new do |s|
  s.name        = 'ierail'
  s.version     = '0.3'
  s.date        = '2012-07-09'
  s.summary     = "Irish Rail Train Schedule and Status API"
  s.description = "Irish Rail Train Schedule and Status API"
  s.authors     = ["Oisin Hurley", "Gary Rafferty"]
  s.email       = 'oi.sin@nis.io'
  s.files       = ["lib/ierail.rb", "lib/station.rb", "lib/station_data.rb","lib/train.rb"]
  s.homepage    = 'http://rubygems.org/gems/ierail'
  s.add_dependency 'nokogiri', '~> 1.5.0'
  s.add_dependency 'rest-client', '~> 1.6.7'
  s.add_dependency 'json', '~> 1.7.7'
end
