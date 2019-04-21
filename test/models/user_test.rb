require 'test_helper'

class UserTest < ActiveSupport::TestCase
   should belong_to(:employee)
   should have_secure_password
   should validate_uniqueness_of(:email)
   
  should allow_value("email@address.com").for(:email)
  should_not allow_value("blos").for(:email)

end
