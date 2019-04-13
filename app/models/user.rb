class User < ApplicationRecord
    belongs_to :employee
    has_secure_password
    
    #when created, must be connected to an employee who is active in the system
    validate :employee_is_active_in_system, on: :create
    #have values which are the proper data type and within proper ranges
    validates_format_of  :email, :with => /^[\+A-Z0-9\._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i, :multiline => true
    #have email addresses that are unique in the system (case doesn't matter)
    validates :email, uniqueness: true
    #are deleted automatically if the employee is deleted
    
end
