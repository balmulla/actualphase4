class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  #before show, destroy, update, edit, create
  before_action :only_admin_and_manager, only: [:create, :new]
  before_action :for_destroy_and_update, only: [:destroy, :update, :edit]
  before_action :for_show, only: [:show]
  
  
  # GET /shifts
  # GET /shifts.json
  def index
    @role = current_user_role
    if @role == "manager" && current_user.employee.current_assignment
      @shifts = Shift.for_store(current_user.employee.current_assignment.store_id)
    end
    if @role == "employee" && current_user.employee.current_assignment
      @shifts = Shift.for_employee(current_user.employee)
    end
    if @role == "admin"
      @shifts = Shift.all
    end
    @shifts = @shifts.upcoming(params[:upcoming]) if params[:upcoming].present?
    @shifts = @shifts.past(params[:past]) if params[:past].present?
    @shifts = @shifts.by_store(params[:by_store]) if params[:by_store].present?
    @shifts = @shifts.by_employee(params[:by_employee]) if params[:by_employee].present?
    @shifts = @shifts.chronological(params[:chronological]) if params[:chronological].present?
    @shifts = @shifts.for_store(params[:for_store]) if params[:for_store].present?
    @shifts = @shifts.for_employee(params[:for_employee]) if params[:for_employee].present?
    @shifts = @shifts.for_next_days((params[:for_next_days]).to_i) if params[:for_next_days].present?
    @shifts = @shifts.for_past_days((params[:for_past_days]).to_i) if params[:for_past_days].present?
    
  end

  # GET /shifts/1
  # GET /shifts/1.json
  def show
    
  end

  # GET /shifts/new
  def new
    @shift = Shift.new
  end

  # GET /shifts/1/edit
  def edit
  end

  # POST /shifts
  # POST /shifts.json
  def create
    @shift = Shift.new(shift_params)

    respond_to do |format|
      if @shift.save
        format.html { redirect_to @shift, notice: 'Shift was successfully created.' }
        format.json { render :show, status: :created, location: @shift }
      else
        format.html { render :new }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shifts/1
  # PATCH/PUT /shifts/1.json
  def update
    respond_to do |format|
      if @shift.update(shift_params)
        format.html { redirect_to @shift, notice: 'Shift was successfully updated.' }
        format.json { render :show, status: :ok, location: @shift }
      else
        format.html { render :edit }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shifts/1
  # DELETE /shifts/1.json
  def destroy
    # @shift.destroy
    # respond_to do |format|
    #   format.html { redirect_to shifts_url, notice: 'Shift was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
    
    respond_to do |format|
      if @shift.destroy
        format.html { redirect_to shifts_url, notice: 'Shift was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to shifts_url, notice: @shift.errors.full_messages}
        format.json { head :no_content }
        
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shift_params
      params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :notes)
    end
    
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def only_admin_and_manager
      @role = current_user_role
      unless @role == "admin" || @role == "manager"
        # redirect_to(root_url) 
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end
    
    def for_destroy_and_update
      @role = current_user_role
      unless @role == "admin" || (@role == "manager" && current_user.employee.current_assignment && @shift.assignment && current_user.employee.current_assignment.store_id == @shift.assignment.store_id )
        # redirect_to(root_url) 
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end
    
    def for_show
      @role = current_user_role
      unless @role == "admin" || (@role == "employee" && @shift.employee == current_user.employee) ||(@role == "manager" && current_user.employee.current_assignment && @shift.assignment && current_user.employee.current_assignment.store_id == @shift.assignment.store_id )
        # redirect_to(root_url) 
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end
end
