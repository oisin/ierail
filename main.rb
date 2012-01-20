$: << File.expand_path(File.join(File.dirname(__FILE__), "lib"))

require 'ierail'

ir = IERail.new

# List all the stations in the system
#
# puts ir.stations

# List all of the trains that are buzzing around at the moment
# and what they are up to
#
# puts ir.trains

# What's the story out in Glenageary station?
#
# puts ir.station("Glenageary")

# Trains due in and out of Glenageary in the next 30 minutes
#
#puts ir.station_times("Glenageary", 30)

# Find stations that match the string partial
#
stations = ir.find_station("gl")

candidates = []
stations.each { |ks| candidates << ks['StationDesc'] }

puts candidates.inspect
