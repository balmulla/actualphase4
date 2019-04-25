class Shift < ApplicationRecord
# Callbacks
  
  before_destroy do
    no_past_destroy
    throw(:abort) if errors.present?
  end
  
  # Relationships
  belongs_to :assignment
  has_one :employee, through: :assignment
  has_one :store, through: :assignment
  has_many :shiftjobs
  has_many :jobs, through: :shiftjobs

  
  # Validations
  validates_presence_of :date, :start_time, :assignment_id
  validates_date :date, on_or_after: lambda { Date.current }, on_or_after_message: "cannot be in the past"
  validates_time :end_time, after: :start_time, allow_blank: true, after_message: "cannot have end time before start time"
  
  #be added to only current assignments, not past assignments
  #validate that assignment ID does not have an end date
  validate :assignment_is_current, on: :create
  

  #methods
  
  #have a method called 'completed?' which returns true or false depending on whether or not there are any jobs associated with that particular shift

  def start_now
    self.update_attribute(:start_time, Time.now)
  end

  def end_now
    self.update_attribute(:end_time, Time.now)
  end
  
  # Scopes
  #'for_store' -- which returns all shifts that are associated with a given store (parameter: store_id)
  scope :for_store,     ->(store_id) { joins(:assignment).where("store_id = ?", store_id) }
  scope :for_employee,  ->(employee_id) { joins(:assignment).where("employee_id = ?", employee_id) }
  scope :past,          -> { where("date < ?", Date.current) }
  scope :upcoming,          -> { where("date >= ?", Date.current) }
  scope :for_next_days,  ->(x) { where("date >= ? and date <= ?", Date.current, Date.current+x) }
  scope :for_past_days,  ->(x) { where("date < ? and date >= ?", Date.current, Date.current-x) }
  scope :chronological, -> { order('date ASC') }
  scope :by_store,      -> { joins(:assignment).joins(:store).order('name') }
  scope :by_employee,   -> { joins(:assignment).joins(:employee).order('last_name, first_name') }
  
  private
  
  def assignment_is_current
    if assignment_id != nil
      assignment = Assignment.find(self.assignment_id)
      unless assignment.end_date==nil
        errors.add(:assignment_id, "is not a current assignment")
      end
    end
  end
  
  def no_past_destroy
      unless date >= Date.current
        errors.add(:base, 'cannot delete past shift')
      end

  end
  
  #new shifts should have a callback which automatically sets the end time to three hours after the start time
  
  
  
end
