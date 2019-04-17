require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  # Test relationships
  should belong_to(:assignment)
  should have_one(:store).through(:assignment)
  should have_one(:employee).through(:assignment)
  
  # Test basic validations
  # for start date
  should_not allow_value(7.weeks.ago.to_date).for(:date)
  should_not allow_value(2.years.ago.to_date).for(:date)
  should allow_value(1.week.from_now.to_date).for(:date)
  should_not allow_value("bad").for(:date)
  should_not allow_value(nil).for(:date)
  should_not allow_value(nil).for(:assignment_id)
  
  
  
  
end
