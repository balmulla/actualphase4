class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  #edit, update, destroy, create admin only
  before_action :only_admin, only: [:edit, :update, :destroy, :create, :new]
  #show, employee, admin, manager
  before_action :for_show, only: [:show]
  #index, manager, admin

  # GET /assignments
  # GET /assignments.json
  def index
    @role = current_user_role
    if @role == "manager"
      @assignments = Assignment.for_store(current_user.employee.current_assignment.store_id).for_role("employee")
    end
    if @role == "employee"
      @assignments = Assignment.for_employee(current_user.employee)
    end
    if @role == "admin"
      @assignments = Assignment.all
    end
    @assignments = @assignments.current(params[:current]) if params[:current].present?
    @assignments = @assignments.past(params[:past]) if params[:past].present?
    @assignments = @assignments.by_store(params[:by_store]) if params[:by_store].present?
    @assignments = @assignments.by_employee(params[:by_employee]) if params[:by_employee].present?
    @assignments = @assignments.chronological(params[:chronological]) if params[:chronological].present?
    @assignments = @assignments.for_store(params[:for_store]) if params[:for_store].present?
    @assignments = @assignments.for_employee(params[:for_employee]) if params[:for_employee].present?
    @assignments = @assignments.for_pay_level(params[:for_pay_level]) if params[:for_pay_level].present?
    @assignments = @assignments.for_role(params[:for_role]) if params[:for_role].present?
    @assignments.uniq
  end

  # GET /assignments/1
  # GET /assignments/1.json
  def show
  end

  # GET /assignments/new
  def new
    @assignment = Assignment.new
  end

  # GET /assignments/1/edit
  def edit
  end

  # POST /assignments
  # POST /assignments.json
  def create
    @assignment = Assignment.new(assignment_params)

    respond_to do |format|
      if @assignment.save
        format.html { redirect_to @assignment, notice: 'Assignment was successfully created.' }
        format.json { render :show, status: :created, location: @assignment }
      else
        format.html { render :new }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1
  # PATCH/PUT /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to @assignment, notice: 'Assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @assignment }
      else
        format.html { render :edit }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    if (@assignment.shifts.past.length==0)
      @assignment.destroy
      respond_to do |format|
        format.html { redirect_to assignments_url, notice: 'Assignment was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      #we terminate
      @assignment.end_date=Date.current
      @assignment.save
      @upcomingshifts=@assignment.shifts.upcoming
      @upcomingshifts.each do |s|
        s.destroy
      end
      respond_to do |format|
        format.html { redirect_to assignments_url, notice: 'Assignment was terminated.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:store_id, :employee_id, :start_date, :end_date, :pay_level)
    end
    
    
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
      unless @role == "admin" || @assignment.employee == current_user.employee || (@role == "manager" && @assignment.employee.role == "employee" && current_user.employee.current_assignment && @assignment.store_id == current_user.employee.current_assignment.store_id)
        # redirect_to(root_url) 
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end      
    end
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
  end
