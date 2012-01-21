class Train
  attr_reader :status, :code, :date, :message, :direction

  def initialize hash
    @status    = hash['TrainStatus']
    @longitude = hash['TrainLongitude']
    @latitude  = hash['TrainLatitude']
    @code      = hash['TrainCode']
    @date      = hash['TrainDate']
    @message   = hash['PublicMessage']
    @direction = hash['Direction']
  end

  def location
    [@longitude,@latitude]
  end
end
