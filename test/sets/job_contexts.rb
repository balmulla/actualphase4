module Contexts
  module JobContexts
    # Context for shifts (assumes contexts for stores, employees, assignments)
    def create_jobs
      @wash = FactoryBot.create(:job)
      @clean = FactoryBot.create(:job, name: "clean dishes")
      @serve = FactoryBot.create(:job, name: "serve icecream", active: false)
    end
    
    def remove_jobs
        @wash.destroy
        @clean.destroy
        @serve.destroy

    end

  end
end