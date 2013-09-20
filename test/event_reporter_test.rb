require 'minitest'
require 'minitest/autorun'
require '../event_reporter'
require 'csv'

class EventReporterTest < Minitest::Test


  def test_it_exists
    er = EventReporter.new
    assert_kind_of EventReporter, er
  end

end




# dont worry abut commands yet - just work on what program needs to do
# load file
# create attendee class with attributes as methods

# create user interface part
# command class with case/if statements 

# third class
# run method
