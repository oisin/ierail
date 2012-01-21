class Station
  attr_reader :description, :code, :id

  def initialize hash
    @description = hash['StationDesc']
    @latitude    = hash['StationLatitude']
    @longitude   = hash['StationLongitude']
    @code        = hash['StationCode']
    @id          = hash['StationId']
  end

  def location
    [@longitude,@latitude]
  end

  alias :name :description
end
