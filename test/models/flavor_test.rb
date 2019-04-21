require 'test_helper'

class FlavorTest < ActiveSupport::TestCase
  #relationship tests
  should have_many(:storeflavors)
  should have_many(:stores).through(:storeflavors)
  
  #validations
  should_not allow_value(nil).for(:name)
  
  context "Creating a context for assignments" do
    setup do
      create_flavors
      
    end

    teardown do
      remove_flavors

    end
    
    should "have a scope 'active' that works" do
      assert_equal 2, Flavor.active.count
    end
    
    should "have a scope 'inactive' that works" do
      assert_equal 1, Flavor.inactive.count
    end
    
    should "have a scope 'alphabetically' that works" do
      assert_equal 3, Flavor.alphabetically.count
      assert_equal [@chocolate,@strawberry, @vanilla], Flavor.alphabetically
    end
    
end
