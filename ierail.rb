require 'rest-client'
require 'nokogiri'

class IERail
  
  URL = "http://api.irishrail.ie/realtime/realtime.asmx"
  
  class IERailGet < Nokogiri::XML::SAX::Document
    
    attr_reader :result
    
    def initialize(url, array_name, object_name)
      @ws_url = url
      @ws_array_name = array_name
      @ws_object_name = object_name
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
  
  class GetStations < IERailGet
    def initialize
      super("getAllStationsXML?", "arrayofobjstation", "objstation")
    end
  end
  
  class GetTrains < IERailGet
    def initialize
      super("getCurrentTrainsXML?", "arrayofobjtrainpositions", "objtrainpositions")
    end
  end
  
  class GetStationData < IERailGet
    def initialize(name)
      super("getStationDataByNameXML?StationDesc=#{name}", "arrayofobjstationdata", "objstationdata")
    end
  end
  
  class GetStationTimes < IERailGet
    def initialize(name, mins)
      super("getStationDataByNameXML_withNumMins?StationDesc=#{name}&NumMins=#{mins}", "arrayofobjstationdata", "objstationdata")
    end
  end
  
  def stations
    GetStations.new.response
  end
  
  def trains
    GetTrains.new.response
  end
  
  def station(name)
    GetStationData.new(name).response
  end
  
  def station_times(name, mins)
    GetStationTimes.new(name, mins).response
  end
end
