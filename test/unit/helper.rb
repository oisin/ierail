require 'simplecov'
require 'coveralls'
require 'tzinfo'
require 'vcr'
require 'timecop'
require 'time'
require 'minitest/autorun'
require 'ierail'

def get_original_time(t)
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

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start
