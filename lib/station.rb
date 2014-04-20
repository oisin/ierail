class Station
  attr_reader :description, :code, :id

  def initialize hash
    @description = hash['StationDesc']
    @latitude    = hash['StationLatitude'].to_f
    @longitude   = hash['StationLongitude'].to_f
    @code        = hash['StationCode']
    @id          = hash['StationId'].to_i
  end

  def location
    [@longitude,@latitude]
  end

  alias :name :description
end
