class ShiftjobsController < ApplicationController
  before_action :set_shiftjob, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  #admin can do all
  # before_action :for_destroy, only: [:destroy]  
  #managers can create destroy shifts associated to their store only
  before_action :for_create, only: [:new, :create] 
  before_action :only_admin, only: [:edit, :update]
  before_action :for_manager_and_admin, only: [:destroy] 
  before_action :for_show, only: [:show]
  
  #forshow




  # GET /shiftjobs
  # GET /shiftjobs.json
  def index
    @role = current_user_role
    @shiftjobs = Shiftjob.all
    if @role == "manager"
      @tempshiftjobs = []
      @shiftjobs.each do |s|
        if s.shift.assignment.employee.role == "employee" && s.shift.assignment.store_id == current_user.employee.current_assignment.store_id
          @tempshiftjobs.append(s)
        end
      end
      @shiftjobs=@tempshiftjobs
    end
    if @role == "employee"
      @tempshiftjobs = []
      @shiftjobs.each do |s|
        if s.shift.assignment && s.shift.assignment.employee_id == current_user.employee.id
          @tempshiftjobs.append(s)
        end
      end
      @shiftjobs=@tempshiftjobs
    end
  end

  # GET /shiftjobs/1
  # GET /shiftjobs/1.json
  def show
  end

  # GET /shiftjobs/new
  def new
    @shiftjob = Shiftjob.new
  end

  # GET /shiftjobs/1/edit
  def edit
  end

  # POST /shiftjobs
  # POST /shiftjobs.json
  def create
    @shiftjob = Shiftjob.new(shiftjob_params)

    respond_to do |format|
      if @shiftjob.save
        format.html { redirect_to @shiftjob, notice: 'Shiftjob was successfully created.' }
        format.json { render :show, status: :created, location: @shiftjob }
      else
        format.html { render :new }
        format.json { render json: @shiftjob.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shiftjobs/1
  # PATCH/PUT /shiftjobs/1.json
  def update
    respond_to do |format|
      if @shiftjob.update(shiftjob_params)
        format.html { redirect_to @shiftjob, notice: 'Shiftjob was successfully updated.' }
        format.json { render :show, status: :ok, location: @shiftjob }
      else
        format.html { render :edit }
        format.json { render json: @shiftjob.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shiftjobs/1
  # DELETE /shiftjobs/1.json
  def destroy
    @shiftjob.destroy
    respond_to do |format|
      format.html { redirect_to shiftjobs_url, notice: 'Shiftjob was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shiftjob
      @shiftjob = Shiftjob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shiftjob_params
      params.require(:shiftjob).permit(:shift_id, :job_id)
    end
    
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # def for_create
    #   @role = current_user_role
    #   unless @role == "admin" || (@role == "manager" && @shiftjob.shift && @shiftjob.shift.assignment && current_user.employee.assignment && @shiftjob.shift.assignment.store_id == current_user.employee.assignment.store_id )
    #     # redirect_to(root_url) 
    #     respond_to do |format|
    #       format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
    #       format.json { head :no_content }
    #     end
    #   end
    # end

    def for_create
      @role = current_user_role
      unless @role == "admin" || @role == "manager"
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end
    
    def only_admin
      @role = current_user_role
      unless @role == "admin"
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end 

    def for_manager_and_admin
      @role = current_user_role
      unless @role == "admin" || (@role == "manager" && current_user.employee.current_assignment && @shiftjob.shift && @shiftjob.shift.assignment && @shiftjob.shift.assignment.store_id && @shiftjob.shift.assignment.store_id == current_user.employee.current_assignment.store_id)
        # redirect_to(root_url) 
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end
    
    def for_show
      @role = current_user_role
      unless @role == "admin" || (@role == "employee" && @shiftjob.shift && @shiftjob.shift.assignment && @shiftjob.shift.assignment.employee == current_user.employee)|| (@role == "manager" && current_user.employee.current_assignment && @shiftjob.shift && @shiftjob.shift.assignment && @shiftjob.shift.assignment.store_id && @shiftjob.shift.assignment.store_id == current_user.employee.current_assignment.store_id)
        # redirect_to(root_url) 
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end
end
