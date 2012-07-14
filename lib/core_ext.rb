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
end
