require 'test_helper'

class ShiftjobTest < ActiveSupport::TestCase
  should belong_to(:shift)
  should belong_to(:job)
  
end
