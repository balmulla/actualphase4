require 'test_helper'

class JobTest < ActiveSupport::TestCase
  #relationship tests
  should have_many(:shiftjobs)
  should have_many(:shifts).through(:shiftjobs)
  
  #validations
  should_not allow_value(nil).for(:name)
end
