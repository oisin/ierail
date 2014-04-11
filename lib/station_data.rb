class StationData
  attr_reader :servertime, :traincode, :station_name, :station_code,
              :status, :last_location, :duein, :late, 
              :train_type, :direction, :query_time, :train_date, :expdepart

  def initialize hash
    @servertime       = hash['Servertime']
    @traincode        = hash['Traincode']
    @station_name     = hash['Stationfullname']
    @station_code     = hash['Stationcode']
    @query_time       = Time.parse(hash['Querytime'])
    @train_date       = hash['Traindate']
    @origin           = hash['Origin']
    @destination      = hash['Destination']
    @origin_time      = Time.parse hash['Origintime']
    @destination_time = Time.parse hash['Destinationtime']
    @status           = hash['Status']
    @last_location    = hash['Lastlocation']
    @duein            = hash['Duein']
    @late             = hash['Late']
    
    # If train origin is station_name, then arrival times will be 00:00, so are adjusted to suit expected origin time.
    # Likewise if destination is station_name, departure times should suit expected destination time.
    # See: http://api.irishrail.ie/realtime/ Point 8
    is_departure_station   = @station_name.eql?(@origin)
    is_terminating_station = @station_name.eql?(@destination)
    
    @exparrival       = is_departure_station ? @origin_time : Time.parse(hash['Exparrival'])
    @expdepart        = is_terminating_station ? @destination_time : Time.parse(hash['Expdepart'])
    @scharrival       = is_departure_station ? @origin_time + @late.to_i : Time.parse(hash['Scharrival'])
    @schdepart        = is_terminating_station ? @destination_time + @late.to_i : Time.parse(hash['Schdepart'])
    @direction        = hash['Direction']
    @train_type       = hash['Traintype']
    
    
  end

  def origin
    {name: @origin, time: @origin_time}
  end

  def destination
    {name: @destination, time: @destination_time}
  end

  def arrival
    {scheduled: @scharrival, expected: @exparrival}
  end

  def departure
    {scheduled: @schdepart, expected: @expdepart}
  end

  def late?
    @late.to_i > 0
  end

  alias :name :station_name
  alias :code :station_code
  alias :due_in :duein
end
