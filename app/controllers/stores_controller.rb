class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]
  before_action :only_admin, only: [:edit, :update, :destroy, :create, :new]

  # GET /stores
  # GET /stores.json
  def index
    if logged_in?
      @stores = Store.all
    else
      @stores = Store.active
    end
    @stores = @stores.active(params[:active]) if params[:active].present?
    @stores = @stores.inactive(params[:inactive]) if params[:inactive].present?
    @stores = @stores.alphabetical(params[:alphabetical]) if params[:alphabetical].present?
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(store_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.active="false"
    @store.save
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully made inactive.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_params
      params.require(:store).permit(:name, :street, :city, :state, :zip, :phone, :latitude, :longitude, :active)
    end
    
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
end
