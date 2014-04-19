class Array
  #Filters elements, collecting those
  #whose times are before _time_
  def before time
    query_time = Time.parse(time)
    select {|t| t.arrival[:expected] <= query_time }
  end

  #Filters elements, collecting those
  #whose times are after _time_
  def after time
    query_time = Time.parse(time)
    select {|t| t.arrival[:expected] >= query_time }
  end

  # The 'in' is just sugar really, saving the 
  # programmer from doing a trivial computation 
  # over and over again in their code.
  def in time
    select { |t| t.due_in <= time }
  end
end
