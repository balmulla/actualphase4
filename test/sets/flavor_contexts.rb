module Contexts
  module FlavorContexts
    # Context for shifts (assumes contexts for stores, employees, assignments)
    def create_flavors
      @vanilla = FactoryBot.create(:flavor)
      @chocolate = FactoryBot.create(:flavor, name: "chocolate")
      @strawberry = FactoryBot.create(:flavor, name: "strawberry", active: false)
    end
    
    def remove_flavors
        @vanilla.destroy
        @chocolate.destroy
        @strawberry.destroy

    end

  end
end