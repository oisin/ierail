class StationData
  attr_reader :servertime, :traincode, :station_name, :station_code,
              :status, :last_location, :duein, :late, 
              :train_type, :direction, :query_time, :train_date, :expdepart

  def initialize hash
    @servertime       = hash['Servertime']
    @traincode        = hash['Traincode']
    @station_name     = hash['Stationfullname']
    @station_code     = hash['Stationcode']
    @query_time       = hash['Querytime']
    @train_date       = hash['Traindate']
    @origin           = hash['Origin']
    @destination      = hash['Destination']
    @origin_time      = hash['Origintime']
    @destination_time = hash['Destinationtime']
    @status           = hash['Status']
    @last_location    = hash['Lastlocation']
    @duein            = hash['Duein']
    @late             = hash['Late']
    @exparrival       = hash['Exparrival']
    @expdepart        = hash['Expdepart']
    @scharrival       = hash['Scharrival']
    @schdepart        = hash['Schdepart']
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
