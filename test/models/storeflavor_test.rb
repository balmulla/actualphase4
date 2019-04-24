require 'test_helper'

class StoreflavorTest < ActiveSupport::TestCase
  should belong_to(:store)
  should belong_to(:flavor)
  
end
