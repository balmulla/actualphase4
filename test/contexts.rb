# require needed files

require './test/sets/store_contexts'
require './test/sets/employee_contexts'
require './test/sets/assignment_contexts'
require './test/sets/shift_contexts'
require './test/sets/shiftjob_contexts'
require './test/sets/job_contexts'

module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::StoreContexts
  include Contexts::EmployeeContexts
  include Contexts::AssignmentContexts
  include Contexts::ShiftContexts
  include Contexts::ShiftjobContexts
  include Contexts::JobContexts
  include Contexts::FlavorContexts
  
  def create_contexts
    create_employees
    create_stores
    create_assignments
    create_shifts
    create_jobs
    create_shiftjobs
    create_flavors
  end
  
  def destroy_contexts
    destroy_employees
    destroy_stores
    destroy_assignments
    destroy_shifts
    destroy_shiftjobs
    destroy_jobs
    destroy_flavors
  end
  

end