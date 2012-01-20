require 'rest-client'
require 'nokogiri'

class IERail
  
  URL = "http://api.irishrail.ie/realtime/realtime.asmx"
  
  class IERailGet < Nokogiri::XML::SAX::Document
    
    attr_reader :result
    
    def initialize(url, array_name, object_name)
      @ws_url = url
      @ws_array_name = array_name.downcase
      @ws_object_name = object_name.downcase
    end
      
    def response
      unless @result
        parser = Nokogiri::XML::SAX::Parser.new(self)
        parser.parse(RestClient.get(URL + "/" + @ws_url))
      end
      @result
    end

    def start_document 
      @result = []
    end
    
    def characters string
      string.strip!
      @result.last[@current] << string unless string.empty?
    end
    
    def start_element name, attrs = []
      case name.downcase
        when @ws_object_name 
          @result << Hash.new
        when @ws_array_name
          ;
        else
          @current = name          
          @result.last[@current] = ""
      end
    end
    
    def end_element name
      if @current && @result.last[@current].empty?
        @result.last.delete(@current)
      end
      @current = nil
    end
  end
  
  # Get ALL the stations!
  # Returns array of hashes, and each hash looks like
  # {
  #    "StationDesc"=>"Belfast Central", 
  #    "StationLatitude"=>"54.6123", 
  #    "StationLongitude"=>"-5.91744", 
  #    "StationCode"=>"BFSTC", 
  #    "StationId"=>"228"
  #  }
  # Returns empty array if no data, but that would be odd.
  #
  def stations
    ier = IERailGet.new("getAllStationsXML?", "arrayofobjstation", "objstation")
    ier.response
  end
  
  # Get ALL the trains! That are on the go at the moment.
  # Returns array of hashes, and each hash looks like
  #  {
  #    "TrainStatus"=>"R", 
  #    "TrainLatitude"=>"53.3509", 
  #    "TrainLongitude"=>"-6.23929", 
  #    "TrainCode"=>"D303", 
  #    "TrainDate"=>"20 Jan 2012", 
  #    "PublicMessage"=>"D303\\n09:30 - Docklands to M3 Parkway (1 mins late)\\nDeparted Docklands next stop Broombridge", 
  #    "Direction"=>"Northbound"
  #  }
  # Returns empty array if no data
  #
  def trains
    ier = IERailGet.new("getCurrentTrainsXML?", "arrayofobjtrainpositions", "objtrainpositions")
    ier.response
  end
  
  # Get train information for a particular station, by station name. This gives data on trains thru that station
  # Returns array of hashes, and each hash looks like
  # {
  #   "Servertime"=>"2012-01-20T10:03:33.777", 
  #   "Traincode"=>"E909", 
  #   "Stationfullname"=>"Glenageary", 
  #   "Stationcode"=>"GLGRY", 
  #   "Querytime"=>"10:03:33", 
  #   "Traindate"=>"20 Jan 2012", 
  #   "Origin"=>"Bray", 
  #   "Destination"=>"Howth", 
  #   "Origintime"=>"09:55", 
  #   "Destinationtime"=>"11:03", 
  #   "Status"=>"En Route", 
  #   "Lastlocation"=>"Arrived Killiney", 
  #   "Duein"=>"6", 
  #   "Late"=>"0", 
  #   "Exparrival"=>"10:09", 
  #   "Expdepart"=>"10:09", 
  #   "Scharrival"=>"10:09", 
  #   "Schdepart"=>"10:09", "
  #   "Direction"=>"Northbound", 
  #   "Traintype"=>"DART", 
  #   "Locationtype"=>"S"
  # }
  # Returns empty array if no data.
  #
  def station(name)
    ier = IERailGet.new("getStationDataByNameXML?StationDesc=#{name}", "arrayofobjstationdata", "objstationdata")
    ier.response
  end
  
  # Get train information for a particular station, by station name, within the time period in minutes from now. 
  # This gives data on trains thru that station.
  # Returns array of hashes, and each hash looks like the one for IERail#station
  # Will return an empty array if no information.
  #
  def station_times(name, mins)
    ier = IERailGet.new("getStationDataByNameXML_withNumMins?StationDesc=#{name}&NumMins=#{mins}", "arrayofobjstationdata", "objstationdata")
    ier.response
  end
  
  # Find station codes and descriptions using a partial string to match the station name
  # Returns an array of hashes that looks like
  # {
  #    "StationDesc_sp"=>"Sandycove", 
  #    "StationDesc"=>"Glasthule (Sandycove )", 
  #    "StationCode"=>"SCOVE"
  #  }
  # or an empty array if no matches.
  #
  def find_station(partial)
    ier = IERailGet.new("getStationsFilterXML?StationText=#{partial}", "ArrayOfObjStationFilter", "objStationFilter")
    ier.response    
  end
end
