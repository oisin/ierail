require 'simplecov'
require 'tzinfo'
require 'vcr'
require 'timecop'
require 'date'
require 'minitest/autorun'
require 'ierail'

def helper_get_original_time(t)
  t = Time.now if t.nil?
  @when = Time.parse(t.to_s)
  if TZInfo::Timezone.get('Europe/Dublin').current_period.dst?
    unless @when.zone == 'IST'
      @when -= @when.utc_offset - 3600
    end
  else
    @when -= @when.utc_offset
  end

  @when
end

def helper_get_thirty_mins
  thirty_mins = Time.now + (60 * 30)
  " #{thirty_mins.hour}:#{thirty_mins.min}" # "HH:MM"
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter
])

SimpleCov.start
