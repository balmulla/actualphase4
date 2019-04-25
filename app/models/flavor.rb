class Flavor < ApplicationRecord
    # Relationships
    has_many :storeflavors
    has_many :stores, through: :storeflavors
    
    # Validations
    validates_presence_of :name
    
    #scopes
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :alphabetical, -> { order('name ASC') }
end
