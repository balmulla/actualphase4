module Contexts
  module ShiftContexts
    # Context for shifts (assumes contexts for stores, employees, assignments)
    def create_shifts
      @shift_kath = FactoryBot.create(:shift, assignment: @assign_kathryn)
      @shift_kath2 = FactoryBot.create(:shift, assignment: @assign_kathryn, date: Date.current+6)
      @shift_cindy = FactoryBot.create(:shift, assignment: @assign_cindy, date: Date.current+7)
      @shift_cindy2 = FactoryBot.create(:shift, assignment: @assign_cindy, date: Date.current+8)
      @shift_ben = FactoryBot.create(:shift, assignment: @promote_ben, date: Date.current+9)
      @shift_ben2 = FactoryBot.create(:shift, assignment: @promote_ben, date: Date.current+10)
      
    end
    
    def remove_shifts
        @shift_kath.destroy
        @shift_kath2.destroy
        @shift_cindy.destroy
        @shift_cindy2.destroy
        @shift_ben.destroy
        @shift_ben2.destroy
    end

  end
end