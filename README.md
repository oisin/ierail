[![Build Status](https://travis-ci.org/oisin/ierail.png?branch=master)](https://travis-ci.org/oisin/ierail)
[![Coverage Status](https://coveralls.io/repos/oisin/ierail/badge.png?branch=master)](https://coveralls.io/r/oisin/ierail)
[![Gem Version](https://badge.fury.io/rb/ierail.png)](http://badge.fury.io/rb/ierail)

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
trains = ir.station('clongriffin', 60)

trains.first.last_location # "Arrived Harmonstown"

trains.first.origin # {:name=>"Greystones", :time=>2013-05-13 22:10:00 +0100}

trains.first.destination # {:name=>"Malahide", :time=>2013-05-13 22:10:00 +0100}

trains.first.arrival # {:scheduled=>2013-05-13 22:09:00 +0100, :expected=>2013-05-13 22:10:00 +0100}

trains.first.departure # {:scheduled=>2013-05-13 22:09:00 +0100, :expected=>2013-05-13 22:10:00 +0100}

trains.first.duein # "2"

trains.first.late? # 0 || 1
```

Check the [main.rb](main.rb) for additional usage.

Pull requests welcome, because there's damn all in it at the moment. Please accompany the pull request with an appropriate test.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/oisin/ierail/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

