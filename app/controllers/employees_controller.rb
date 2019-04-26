class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, :only => [:index, :show]
  before_action :logged_in_user
  #edit, update, destroy, create admin only
  before_action :only_admin, only: [:destroy, :create, :new]
  #show, employee, admin, manager
  before_action :for_show, only: [:show]
  #index, manager, admin
  before_action :for_index, only: [:index]
  before_action :for_edit, only: [:edit, :update]

  # GET /employees
  # GET /employees.json
  def index
    @role = current_user_role
    if @role == "manager" && current_user.employee.current_assignment
      @employees = Employee.regulars.for_store(current_user.employee.current_assignment.store_id)
    else
      @employees = Employee.all
    end
    @employees = @employees.active(params[:active]) if params[:active].present?
    @employees = @employees.inactive(params[:inactive]) if params[:inactive].present?
    @employees = @employees.younger_than_18(params[:younger_than_18]) if params[:younger_than_18].present?
    @employees = @employees.is_18_or_older(params[:is_18_or_older]) if params[:is_18_or_older].present?
    @employees = @employees.regulars(params[:regulars]) if params[:regulars].present?
    @employees = @employees.managers(params[:managers]) if params[:managers].present?
    @employees = @employees.admins(params[:admins]) if params[:admins].present?
    @employees = @employees.alphabetical(params[:alphabetical]) if params[:alphabetical].present?
    @employees = @employees.for_store(params[:for_store]) if params[:for_store].present?
    
    @employees= @employees.uniq
  end
  
  # def active
  #   @active = Employee.active
  # end
  
  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
    @employee.build_user

  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    if (Shift.for_employee(@employee.id).count == 0)
      @employee.destroy
      if @employee.user.present?
        @employee.user.destroy
      end
      # their assignment (if it exists) should also be deleted
      Assignment.for_employee(@employee).each { |item|
        item.destroy
      }
      respond_to do |format|
        format.html { redirect_to employees_url, notice: 'Employee and user were successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      #the employee should be made inactive
      @employee.active=false
      @employee.save
      #their current assignment terminated
      @assignment= @employee.current_assignment
      unless @assignment == nil
        @assignment.end_date = Date.current
        @assignment.save
      end
      #all future shifts should be deleted.
      Shift.for_employee(@employee).upcoming.each { |item|
        item.destroy
      }
      
      respond_to do |format|
        format.html { redirect_to employees_url, notice: 'Employee could not be deleted, employee is now inactive.' }
        format.json { head :no_content }
      end
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
       params.require(:employee).permit(:phone, :active, :first_name, :last_name, :ssn, :date_of_birth, :role, user_attributes: [:id, :email, :password])
    end
    
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    #methods for authorisation
    
    #admins can do everything
    

    def only_admin
      @role = current_user_role
      unless @role == "admin"
        # redirect_to(root_url) 
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end
    
    #show definition
    
    def for_show
    @role = current_user_role
      unless @role == "admin" || @employee == current_user.employee || (@role == "manager" && @employee.role == "employee" && @employee.current_assignment && current_user.employee.current_assignment && @employee.current_assignment.store_id == current_user.employee.current_assignment.store_id)
        # redirect_to(root_url) 
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end      
    end
    def for_index
      @role = current_user_role
      unless @role == "admin" || @role == "manager"
        # redirect_to(root_url) 
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end
    def for_edit
      @role = current_user_role
      unless @role == "admin" || @employee == current_user.employee
        # redirect_to(root_url) 
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end
end
