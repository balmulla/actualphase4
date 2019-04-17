class Shift < ApplicationRecord
  #can only be deleted if the shift is scheduled for today or in the future
#   before_destroy :no_past_destroy
  
  before_destroy do
    no_past_destroy
    throw(:abort) if errors.present?
  end
  
  # Relationships
  belongs_to :assignment
  has_one :employee, through: :assignment
  has_one :store, through: :assignment

  
  # Validations
  validates_presence_of :date, :start_time, :assignment_id
#   validates_date :date, on_or_after: lambda { Date.current }, on_or_after_message: "cannot be in the past"
  validates_time :end_time, after: :start_time, allow_blank: true
  
  #be added to only current assignments, not past assignments
  #validate that assignment ID does not have an end date
  validate :assignment_is_current, on: :create
  

  
  
  
  private
  
  def assignment_is_current
    assignment = Assignment.find(self.assignment_id)
    unless assignment.end_date==nil
      errors.add(:assignment_id, "is not a current assignment")
    end
  end
  
  def no_past_destroy
      unless date >= Date.current
        errors.add(:base, 'cannot delete past assignments')
      end

  end
  
  
  
end
