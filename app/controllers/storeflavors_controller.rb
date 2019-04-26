class StoreflavorsController < ApplicationController
  before_action :set_storeflavor, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  before_action :only_admin, only: [:edit, :update]
  before_action :only_admin_and_manager, only: [:index, :show, :create, :new]
  before_action :for_destroy, only: [:destroy]

  # GET /storeflavors
  # GET /storeflavors.json
  def index
    @storeflavors = Storeflavor.all
    @role = current_user_role
    if @role == "manager"
      @tempstores = []
      @storeflavors.each do |s|
        if s.store == current_user.employee.current_assignment.store
          @tempstores.append(s)
        end
      end
      @storeflavors=@tempstores
    end
  end

  # GET /storeflavors/1
  # GET /storeflavors/1.json
  def show
  end

  # GET /storeflavors/new
  def new
    @storeflavor = Storeflavor.new
  end

  # GET /storeflavors/1/edit
  def edit
  end

  # POST /storeflavors
  # POST /storeflavors.json
  def create
    @storeflavor = Storeflavor.new(storeflavor_params)

    respond_to do |format|
      if @storeflavor.save
        format.html { redirect_to @storeflavor, notice: 'Storeflavor was successfully created.' }
        format.json { render :show, status: :created, location: @storeflavor }
      else
        format.html { render :new }
        format.json { render json: @storeflavor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /storeflavors/1
  # PATCH/PUT /storeflavors/1.json
  def update
    respond_to do |format|
      if @storeflavor.update(storeflavor_params)
        format.html { redirect_to @storeflavor, notice: 'Storeflavor was successfully updated.' }
        format.json { render :show, status: :ok, location: @storeflavor }
      else
        format.html { render :edit }
        format.json { render json: @storeflavor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /storeflavors/1
  # DELETE /storeflavors/1.json
  def destroy
    @storeflavor.destroy
    respond_to do |format|
      format.html { redirect_to storeflavors_url, notice: 'Storeflavor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_storeflavor
      @storeflavor = Storeflavor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def storeflavor_params
      params.require(:storeflavor).permit(:store_id, :flavor_id)
    end
    
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
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
    
    def only_admin_and_manager
      @role = current_user_role
      unless @role == "admin" || @role == "manager"
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end 
    
    def for_destroy
      @role = current_user_role
      unless @role == "admin" || @role == "manager" && current_user.employee.current_assignment && @storeflavor.store == current_user.employee.current_assignment.store
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'You are not authorised to do that' }
          format.json { head :no_content }
        end
      end
    end 
end
