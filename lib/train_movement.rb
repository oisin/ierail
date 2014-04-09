class TrainMovement
  
  attr_reader :location_full_name

  def initialize hash
    @train_code          = hash['TrainCode']
    @train_date          = Time.parse hash['TrainDate']
    @location_code       = hash['LocationCode'] 
    @location_full_name  = hash['LocationFullName']
    @location_order      = hash['LocationOrder'].to_i
    @location_type       = hash['LocationType']
    @train_origin        = hash['TrainOrigin']
    @scheduled_arrival   = Time.parse hash['ScheduledArrival']
    @scheduled_departure = Time.parse hash['ScheduledDeparture']
    @expected_arrival    = Time.parse hash['ExpectedArrival']
    @expected_departure  = Time.parse hash['ExpectedDeparture']
    arrival_time         = hash['Arrival']
    departure_time       = hash['Departure']
    @arrival             = arrival_time.nil? ? @expected_arrival : Time.parse(arrival_time)
    @departure           = departure_time.nil? ? @expected_departure : Time.parse(departure_time)
  end
  
  def location
    {code: @location_code, name: @location_full_name, stop_number: @location_order, type: @location_type}
  end

  def arrival
    {scheduled: @scheduled_arrival, expected: @expected_arrival, actual: @arrival}
  end
  
  def departure
    {scheduled: @scheduled_departure, expected: @expected_departure, actual: @departure}
  end
  
  def train
    {code: @train_code, date: @train_date, origin: @train_origin}
  end

  alias :station :location_full_name
end
