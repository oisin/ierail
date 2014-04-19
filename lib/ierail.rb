require 'rest-client'
require 'nokogiri'
require 'uri'
require 'time'

require 'train'
require 'station'
require 'station_data'
require 'train_movement'
require 'core_ext'

class IERail
  
  URL = "http://api.irishrail.ie/realtime/realtime.asmx"
  
  class IERailGet < Nokogiri::XML::SAX::Document
    
    attr_reader :result
    
    def initialize(url, array_name, object_name)
      @ws_url = URI.encode(url)
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
  # Returns array of Station objects, and each object responds to
  # {
  #    obj#name =>"Belfast Central", 
  #    obj#location =>["-5.91744", "54.6123"] 
  #    obj#code =>"BFSTC", 
  #    obj#id =>"228"
  #  }
  # Returns empty array if no data, but that would be odd.
  #
  def stations
    ier = IERailGet.new("getAllStationsXML?", "arrayofobjstation", "objstation")
    
    ier.response.map { |s| Station.new(s) }
  end
  
  # Get ALL the trains! That are on the go at the moment.
  # Returns array of Train objects, and each object responds to
  #  {
  #    obj#status =>"R", 
  #    obj#location =>["-6.23929, ""53.3509"] 
  #    obj#code =>"D303", 
  #    obj#date =>"20 Jan 2012", 
  #    obj#message =>"D303\\n09:30 - Docklands to M3 Parkway (1 mins late)\\nDeparted Docklands next stop Broombridge", 
  #    obj#direction =>"Northbound"
  #  }
  # Returns empty array if no data
  #
  def trains
    ier = IERailGet.new("getCurrentTrainsXML?", "arrayofobjtrainpositions", "objtrainpositions")
    
    ier.response.map { |t| Train.new(t) }
  end
  
  # Get train information for a particular station, by station name. This gives data on trains thru that station
  # Returns array of StationData objects, and each object responds to
  # {
  #   obj#server_time =>"2012-01-20T10:03:33.777", 
  #   obj#train_code =>"E909", 
  #   obj#name / obj#station_name =>"Glenageary", 
  #   obj#code / obj#station_code =>"GLGRY", 
  #   obj#query_time =>"10:03:33", 
  #   obj#train_date =>"20 Jan 2012", 
  #   obj#origin => {:name => "Bray", :time => "09:55"} 
  #   obj#destination => {:name => "Howth", :time => "11:03"} 
  #   obj#status =>"En Route", 
  #   obj#last_location =>"Arrived Killiney", 
  #   obj#due_in =>"6", 
  #   obj#minutes_early => 0
  #   obj#minutes_late => 0,
  #   obj#on_time? => true / false,
  #   obj#early? => true / false,
  #   obj#late? => true / false,
  #   obj#arrival => {:scheduled => "10:09", :expected => "10:09"}
  #   obj#departure => {:scheduled => "10:09", :expected => "10:09"}
  #   obj#direction => "Northbound",
  #   obj#train_type => "DART", 
  # }
  # Returns empty array if no data.
  #
  def station(name)
    ier = IERailGet.new("getStationDataByNameXML?StationDesc=#{name}", "arrayofobjstationdata", "objstationdata")
    
    ier.response.map { |sd| StationData.new(sd) }
  end
  
  # Get train information for a particular station, by station name, within the time period in minutes from now. 
  # This gives data on trains thru that station.
  # Returns array of StationData objects, and each obj looks like the one for IERail#station
  # Will return an empty array if no information.
  #
  def station_times(name, mins)
    ier = IERailGet.new("getStationDataByNameXML_withNumMins?StationDesc=#{name}&NumMins=#{mins}", "arrayofobjstationdata", "objstationdata")
    
    ier.response.map { |sd| StationData.new(sd) }
  end
  
  # Get the movements of a particular train, by train code, on a date.
  #  If no date is supplied assume train has run/is running today.
  #
  # This gives all the stations that the train has or will be stopped at.
  # Returns an array of TrainMovement objects, and each object responds to
  # {
  #    obj#location => {code: "GLGRY", name: "Glenageary", stop_number: 1 (Stop number on route), type: "O" (Origin) \ "S" (Stop) \ "D" (Destination)}
  #    obj#train => {:code => "E909", :date => "20 Jan 2012", :origin => "Glenageary"}
  #    obj#arrival => {:scheduled => "10:09", :expected => "10:09", :actual => "10.09"}
  #    obj#departure => {:scheduled => "10:09", :expected => "10:09", :actual => "10.09"}
  #    obj#station => "Glenageary"
  # }
  #
  def train_movements(code, date=Time.now)
    ier = IERailGet.new("getTrainMovementsXML?TrainId=#{code}&TrainDate=#{date.strftime("%d/%m/%Y")}", "ArrayOfObjTrainMovements", "ObjTrainMovements")
    
    ier.response.map{ |tm| TrainMovement.new(tm) }
  end
  
  # Find station codes and descriptions using a partial string to match the station name
  # Returns an array of Structs that each respond to
  # {
  #    struct#name =>"Sandycove", 
  #    struct#description =>"Glasthule (Sandycove )", 
  #    struct#code =>"SCOVE"
  #  }
  # or an empty array if no matches.
  #
  def find_station(partial)
    ier = IERailGet.new("getStationsFilterXML?StationText=#{partial}", "ArrayOfObjStationFilter", "objStationFilter")
    Struct.new("Station", :name, :description, :code)
    
    ier.response.map do |st|
       Struct::Station.new(st['StationDesc_sp'],
                           st['StationDesc'],
                           st['StationCode'])
    end
  end

  # Get direction-specific train information for a particular station, by station name. 
  # This gives data on trains through that station
  # Returns array of StationData objects, and each object responds to
  # {
  #   obj#servertime =>"2012-01-20T10:03:33.777", 
  #   obj#traincode =>"E909", 
  #   obj#name / obj#station_name =>"Glenageary", 
  #   obj#code / obj#station_code =>"GLGRY", 
  #   obj#query_time =>"10:03:33", 
  #   obj#train_date =>"20 Jan 2012", 
  #   obj#origin => {:name => "Bray", :time => "09:55"} 
  #   obj#destination => {:name => "Howth", :time => "11:03"} 
  #   obj#status =>"En Route", 
  #   obj#last_location =>"Arrived Killiney", 
  #   obj#duein / obj#due_in =>"6", 
  #   obj#late =>"0", 
  #   obj#late? => 0 / 1
  #   obj#arrival => {:scheduled => "10:09", :expected => "10:09"}
  #   obj#departure => {:scheduled => "10:09", :expected => "10:09"}
  #   obj#direction => "Northbound",
  #   obj#train_type => "DART", 
  # }
  # Returns empty array if no data.
  #

  def method_missing(name, *args, &block)
    # Only handle *bound_from (e.g northbound_from / southbound_from)
    if name =~ /bound_from/
      direction = name.to_s.split('_').first.capitalize

      ier = IERailGet.new("getStationDataByNameXML?StationDesc=#{args.first}", "arrayofobjstationdata", "objstationdata")
     
      ier.response.select { |sd| sd['Direction'] == direction }.map { |sd| StationData.new(sd) }
    end
  end
end
