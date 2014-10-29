[![Build Status](https://travis-ci.org/oisin/ierail.png?branch=master)](https://travis-ci.org/oisin/ierail)
[![Coverage Status](https://coveralls.io/repos/oisin/ierail/badge.png?branch=master)](https://coveralls.io/r/oisin/ierail)
[![Gem Version](https://badge.fury.io/rb/ierail.png)](http://badge.fury.io/rb/ierail)
[![Dependency Status](https://gemnasium.com/oisin/ierail.svg)](https://gemnasium.com/oisin/ierail)
[![Code Climate](https://codeclimate.com/github/oisin/ierail/badges/gpa.svg)](https://codeclimate.com/github/oisin/ierail)

## Irish Rail API Ruby Wrapper

I wrote most of this on the train, as is appropriate. 

It's a trivial wrapper for the Irish Rail real time (whut?) train times system, in Ruby. It uses the HTTP GET API that was thankfully supplied along with the more *interesting* SOAP API, so a tiddly simple set up with [RestClient](https://github.com/archiloque/rest-client) and [Nokogiri](http://nokogiri.org/) (two of my favourite things ever) to pull and process the XML data into Hashes for great value.

## Usage

### Grab the IERail gem


```bash
$ gem install ierail
```

```ruby
require 'ierail'

ir = IERail.new
```

### Find all Southbound trains serving Clongriffin station

```ruby
trains = ir.southbound_from('clongriffin')
```

### Find all trains serving Clongriffin in the next 30 minutes

```ruby
trains = ir.station_times('clongriffin', 30)

trains.each { |t| p t.inspect }
```

### Find all Northbound trains serving Clongriffin before / after a certain time

```ruby
trains = ir.northbound_from('clongriffin').after('HH:MM')
trains = ir.northbound_from('clongriffin').before('HH:MM')
```

NB: "HH:MM" must be soon, as the API, by default, returns upcoming
arrivals

### Find all Southbound trains from Malahide in the next N minutes

```ruby
trains = ir.southbound_from('malahide').in(N)
```

### Find out information for a specific train

```ruby
trains = ir.station_times('clongriffin', 60)

trains.first.last_location # "Arrived Harmonstown"

trains.first.origin # {:name=>"Greystones", :time=>2013-05-13 22:10:00 +0100}

trains.first.destination # {:name=>"Malahide", :time=>2013-05-13 22:10:00 +0100}

trains.first.arrival # {:scheduled=>2013-05-13 22:09:00 +0100, :expected=>2013-05-13 22:10:00 +0100}

trains.first.departure # {:scheduled=>2013-05-13 22:09:00 +0100, :expected=>2013-05-13 22:10:00 +0100}

trains.first.duein # "2"

trains.first.late? # 0 || 1
```

### Find out the movements of a specific train

```ruby
trains = ir.station_times('clongriffin', 60)

train_code = trains.first.code

train_movements = ir.train_movements(train_code) # Gets the movements of the train for today
train_movements = ir.train_movements(train_code, date) # Gets the movements of train for some date

fourth_stop = train_movements.at(4)

fourth_stop.location #{:code => "GRGD", :location_full_name => "Clongriffin", :stop_number => 4, :location_type => "S"}

fourth_stop.arrival # {:scheduled=>2013-05-13 22:09:00 +0100, :expected=>2013-05-13 22:10:00 +0100, :actual=2013-05-13 22:10:00 +0100}

fourth_stop.departure # {:scheduled=>2013-05-13 22:09:00 +0100, :expected=>2013-05-13 22:10:00 +0100, :actual=2013-05-13 22:10:00 +0100}

fourth_stop.train #{:code => "E808", :date => 2013-05-13 22:09:00 +0100, :origin => "Malahide"}
```


Check the [main.rb](main.rb) for additional usage.

## Development

### Testing

Rather than having the test suite hit the API, this project is using [VCR](https://github.com/vcr/vcr) alongside [Timecop](https://github.com/travisjeffery/timecop) to use stubbed responses.  
These responses are stored in the `fixtures/vcr_cassettes` directory and can be updated by running

1. `rm -r fixtures`
2. `rake test`

As the API functionality is highly time dependent, Timecop is used to set/freeze time so that we can run time based queries on the older fixture data.

---

Pull requests welcome, because there's damn all in it at the moment. Please accompany the pull request with an appropriate test, and if you can, an example here in the README.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/oisin/ierail/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

