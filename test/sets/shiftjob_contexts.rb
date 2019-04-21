module Contexts
  module ShiftjobContexts
    # Context for shifts (assumes contexts for stores, employees, assignments)
    def create_shiftjobs
      @cleanshift = FactoryBot.create(:shiftjob, job: @clean, shift: @shift_kath2)
    end
    
    def remove_shiftjobs
        @cleanshift.destroy
    end

  end
end