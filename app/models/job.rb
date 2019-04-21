class Job < ApplicationRecord
    before_destroy do
        unless not_worked?
            throw(:abort)
        end
    end
    
     # Relationships
    has_many :shiftjobs
    has_many :shifts, through: :shiftjobs
    
    # Validations
    validates_presence_of :name
    
    #scopes
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :alphabetically, -> { order('name ASC') }
    
    def not_worked?
        @result=true
        unless (Shiftjob.where("job_id = ?", id).count ==0)
            @result=false
            errors.add(:base, 'cannot delete will make inactive')
        end
        @result
    end
    
end
