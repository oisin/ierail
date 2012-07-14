class Array
  #Filters elements, collecting those
  #whose times are before _time_
  def before time
    select {|t| Time.parse(t.expdepart) <= Time.parse(time) }
  end

  #Filters elements, collecting those
  #whose times are after _time_
  def after time
    select {|t| Time.parse(t.expdepart) >= Time.parse(time) }
  end

  # The 'in' is just sugar really, saving the 
  # programmer from doing a trivial computation 
  # over and over again in their code.
  def in time
    future_time = Time.now + (time * 60)
    before "#{future_time.hour}:#{future_time.min}"
  end
end
