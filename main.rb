$: << File.dirname(__FILE__)

require 'ierail'

ir = IERail.new

# List all the stations in the system
#
puts ir.stations

# List all of the trains that are buzzing around at the moment
# and what they are up to
#
puts ir.trains

# What's the story out in Bray station?
#
puts ir.station("BRAY")

# Trains due in and out of Bray in the next 30 minutes
#
puts ir.station_times("BRAY", 30)
