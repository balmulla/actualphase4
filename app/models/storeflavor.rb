class Storeflavor < ApplicationRecord
    # Relationships
    belongs_to :store
    belongs_to :flavor
end
