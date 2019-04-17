class User < ApplicationRecord
    belongs_to :employee
    has_secure_password
    
    # attr_accessible :active

    # validates :active, acceptance: true
    
    #this does not work because it checks these and then it creates the employee and then the user
    # validate :employee_is_active_in_system, on: :create

    
    #when created, must be connected to an employee who is active in the system
    #have values which are the proper data type and within proper ranges
    validates_format_of  :email, :with => /^[\+A-Z0-9\._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i, :multiline => true
    #have email addresses that are unique in the system (case doesn't matter)
    validates :email, uniqueness: true
    #are deleted automatically if the employee is deleted
    
    # private
    # # Again, these are not DRY
    # def employee_is_active_in_system
    #     all_active_employees = Employee.active.all.map{|e| e.id}
    #     unless all_active_employees.include?(self.employee_id)
    #         errors.add(:employee_id, "is not an active employee at the creamery")
    #     end
    # end
    

    
end
