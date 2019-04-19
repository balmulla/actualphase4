require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  # Test relationships
  should belong_to(:assignment)
  should have_one(:store).through(:assignment)
  should have_one(:employee).through(:assignment)
  should have_many(:shiftjobs)
  should have_many(:jobs).through(:shiftjobs)
  
  # Test basic validations
  # for start date
  should_not allow_value(7.weeks.ago.to_date).for(:date)
  should_not allow_value(2.years.ago.to_date).for(:date)
  should allow_value(1.week.from_now.to_date).for(:date)
  should_not allow_value("bad").for(:date)
  should_not allow_value(nil).for(:date)
  should_not allow_value(nil).for(:assignment_id)
  should_not allow_value(nil).for(:start_time)
  
  
  # # Need to do the rest with a context
  context "Creating a context for assignments" do
    setup do
      create_stores
      create_employees
      create_assignments
      create_shifts
    end

    teardown do
      remove_stores
      remove_employees
      remove_assignments
      remove_shifts
      
    end
    
    should " allow shift creation if assignment is current" do
      @shift_ben3 = FactoryBot.create(:shift, assignment: @promote_ben)
      assert_not_equal nil, @shift_ben3
      @shift_ben3.destroy
    end
    
    should " not allow shift creation if assignment is not current" do
      @shift_ben3 = Shift.create(assignment_id: @assign_ben.id, date: Date.current, start_time: Time.now, end_time: Time.now+3600)
      assert_equal ["Assignment is not a current assignment"], @shift_ben3.errors.full_messages
      @shift_ben3.destroy
    end
    
    should " allow update start time to current time" do
      @shift_ben3 = FactoryBot.create(:shift, assignment: @promote_ben)
      @shift_ben3.start_now
      assert_equal @shift_kath.start_time.hour, Time.now.hour
      @shift_ben3.destroy
    end
    
    should " allow update end time to current time" do
      @shift_kath.end_now
      assert_equal @shift_kath.end_time.hour, Time.now.hour
    end
    
    should " not destroy a past shift" do
      @shift_ben3 = Shift.new(assignment_id: @promote_ben.id, date: Date.current-1, start_time: Time.now, end_time: Time.now+3600)
      @shift_ben3.save(validate: false)
      @shift_ben3.destroy
      assert_not_equal nil, @shift_ben3
      @shift_ben3.date=(Date.current)
      @shift_ben3.save
      @shift_ben3.destroy
      
    end
    
    

    
  end
  
end
