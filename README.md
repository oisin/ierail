## Irish Rail API Ruby Wrapper

I wrote most of this on the train, as is appropriate. 

It's a trivial wrapper for the Irish Rail real time (whut?) train times system, in Ruby. It uses the HTTP GET API that was thankfully supplied along with the more *interesting* SOAP API, so a tiddly simple set up with [RestClient](https://github.com/archiloque/rest-client) and [Nokogiri](http://nokogiri.org/) (two of my favourite things ever) to pull and process the XML data into Hashes for great value.

## Usage

### Grab the IERail gem

gem install ierail

require 'ierail'

ir = IERail.new

### Find all Southbound trains serving Clongriffin station

trains = ir.station('clongriffin')

trains.each { |t| puts t.inspect if t.direction == 'Southbound' }

### Find all trains serving Clongriffin in the next 30 minutes

trains = ir.station_times('clongriffin', 30)

trains.each { |t| puts t.inspect }

### Find out information for a specific train

trains = ir.station('clongriffin', 60)

trains.first.last_location # "Arrived Harmonstown"

trains.first.origin # {:name=>"Greystones", :time=>"07:30"}

trains.first.destination # {:name=>"Malahide", :time=>"08:49"}

trains.first.arrival # {:scheduled=>"08:40", :expected=>"08:41"}

trains.first.departure # {:scheduled=>"08:41", :expected=>"08:41"}

trains.first.duein # "2"

trains.first.late? # 0 || 1

Check the **main.rb** for additional usage.

Pull requests welcome, because there's damn all in it at the moment. Please accompany the pull request with an appropriate test.
