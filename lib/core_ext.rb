class Array
  #Filters elements, collecting those
  #whose times are before _time_
  def before time
    select {|t| t.expected_departure <= Time.parse(time) }
  end

  #Filters elements, collecting those
  #whose times are after _time_
  def after time
    select {|t| t.expected_departure >= Time.parse(time) }
  end

  # The 'in' is just sugar really, saving the 
  # programmer from doing a trivial computation 
  # over and over again in their code.
  def in time
    select { |t|
      ((t.expected_departure - t.query_time ) / 60) < time
    }
  end
end
