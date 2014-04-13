class StationData
  attr_reader :servertime, :traincode, :station_name, :station_code,
              :status, :last_location, :duein, :minutes_late, :minutes_early,
              :train_type, :direction, :query_time, :train_date, :expdepart

  def initialize hash
    @servertime          = Time.parse hash['Servertime']
    @traincode           = hash['Traincode']
    @station_name        = hash['Stationfullname']
    @station_code        = hash['Stationcode']
    @query_time          = Time.parse hash['Querytime']
    @train_date          = Date.parse hash['Traindate']
    @origin              = hash['Origin']
    @destination         = hash['Destination']
    @origin_time         = Time.parse hash['Origintime']
    @destination_time    = Time.parse hash['Destinationtime']
    @status              = hash['Status']
    @last_location       = hash['Lastlocation']
    @duein               = hash['Duein'].to_i

    # Though IE give a late value, this really represents difference from scheduled arrival
    # and therefore represents the number of minutes that the train is off-schedule where
    # <0: early, 0: on time and >0: late

    off_schedule_minutes = hash['Late'].to_i
    @minutes_late        = off_schedule_minutes > 0 ? off_schedule_minutes : 0
    @minutes_early       = off_schedule_minutes < 0 ? -off_schedule_minutes : 0
    
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
    @minutes_late > 0
  end

  def early?
    @minutes_early > 0
  end

  def on_time?
    !late? && !early?
  end

  alias :name :station_name
  alias :code :station_code
  alias :due_in :duein
end
