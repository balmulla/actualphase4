class FlavorsController < ApplicationController
  before_action :set_flavor, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  before_action :only_admin, only: [:edit, :update, :create, :new, :destroy]
  before_action :only_admin_and_manager, only: [:index, :show]

  # GET /flavors
  # GET /flavors.json
  def index
    @flavors = Flavor.all
    @flavors = @flavors.active(params[:active]) if params[:active].present?
    @flavors = @flavors.inactive(params[:inactive]) if params[:inactive].present?
    @flavors = @flavors.alphabetical(params[:alphabetical]) if params[:alphabetical].present?
  end

  # GET /flavors/1
  # GET /flavors/1.json
  def show
  end

  # GET /flavors/new
  def new
    @flavor = Flavor.new
  end

  # GET /flavors/1/edit
  def edit
  end

  # POST /flavors
  # POST /flavors.json
  def create
    @flavor = Flavor.new(flavor_params)

    respond_to do |format|
      if @flavor.save
        format.html { redirect_to @flavor, notice: 'Flavor was successfully created.' }
        format.json { render :show, status: :created, location: @flavor }
      else
        format.html { render :new }
        format.json { render json: @flavor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flavors/1
  # PATCH/PUT /flavors/1.json
  def update
    respond_to do |format|
      if @flavor.update(flavor_params)
        format.html { redirect_to @flavor, notice: 'Flavor was successfully updated.' }
        format.json { render :show, status: :ok, location: @flavor }
      else
        format.html { render :edit }
        format.json { render json: @flavor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flavors/1
  # DELETE /flavors/1.json
  def destroy
    @flavor.active="false"
    @flavor.save
    respond_to do |format|
      format.html { redirect_to flavors_url, notice: 'Flavor was successfully made inactive.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flavor
      @flavor = Flavor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flavor_params
      params.require(:flavor).permit(:name, :active)
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
end
