class Train
  attr_reader :status, :code, :date, :message, :direction

  def initialize hash
    @status    = hash['TrainStatus']
    @longitude = hash['TrainLongitude'].to_f
    @latitude  = hash['TrainLatitude'].to_f
    @code      = hash['TrainCode']
    @date      = Date.parse hash['TrainDate']
    @message   = hash['PublicMessage']
    @direction = hash['Direction']
  end

  def location
    [@longitude,@latitude]
  end
end
