require 'test_helper'

class JobTest < ActiveSupport::TestCase
  #relationship tests
  should have_many(:shiftjobs)
  should have_many(:shifts).through(:shiftjobs)
  
  #validations
  should_not allow_value(nil).for(:name)
  
  context "Creating a context for assignments" do
    setup do
      create_stores
      create_employees
      create_assignments
      create_shifts
      create_jobs
      create_shiftjobs
      
    end

    teardown do
      remove_stores
      remove_employees
      remove_assignments
      remove_jobs
      remove_shifts
      remove_shiftjobs
    end
    
    should "have a scope 'active' that works" do
      assert_equal 2, Job.active.count
    end
    
    should "have a scope 'inactive' that works" do
      assert_equal 1, Job.inactive.count
    end
    
    should "have a scope 'alphabetically' that works" do
      assert_equal 3, Job.alphabetically.count
      assert_equal [@clean,@serve, @wash], Job.alphabetically
    end
    
  end
end
