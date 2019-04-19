class Job < ApplicationRecord
    # before_destroy do
    #     not_worked
    #     throw(:abort) if errors.present?
    # end
     # Relationships
    has_many :shiftjobs
    has_many :shifts, through: :shiftjobs
    
    # Validations
    validates_presence_of :name
    
    #scopes
    scope :active, -> { where("active = true") }
    scope :inactive, -> { where("active = false") }
    scope :alphabetically, -> { order('name ASC') }
    
    # def not_worked
    #   unless date >= Date.current
    #     errors.add(:base, 'cannot delete a job that has been worked')
    #   end
    # end
    
end
