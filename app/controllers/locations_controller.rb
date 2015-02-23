class LocationsController < ApplicationController
	before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all
    respond_to do |format|
     	format.html # index.html
    	format.json { render json: @locations, each_serializer: LocationSerializer }
      #LocationSerializer is where we setup fancnt
  	end
  end

  def fav
    @locations = Location.where("id in (select location_id from user_location_favs where user_id = :user_id) " ,{user_id: current_user.id})
    respond_to do |format|
      format.html # index.html
      format.json { render json: @locations, each_serializer: LocationSerializer }
      #LocationSerializer is where we setup fancnt
    end
  end

  def pop
    @locations = Location.where("id in (select distinct location_id from user_location_favs )" )
    respond_to do |format|
      format.html # index.html
      format.json { render json: @locations, each_serializer: LocationSerializer }
      #LocationSerializer is where we setup fancnt
    end
  end

  def hot
    @locations = Location.all
    respond_to do |format|
      format.html # index.html
      format.json { render json: @locations, each_serializer: LocationSerializer }
      #LocationSerializer is where we setup fancnt
    end
  end

  def cool
    @locations = Location.all
    respond_to do |format|
      format.html # index.html
      format.json { render json: @locations, each_serializer: LocationSerializer }
      #LocationSerializer is where we setup fancnt
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
    @doors = @location.doors
    @rooms = @location.rooms

  end

  # GET /locations/new
  def new
    @location = Location.new
    door = @location.doors.build
    room = @location.rooms.build
  end

  # GET /locations/1/edit
  def edit
		logger.info "redis-config ENV : #{ENV.inspect}"
    door = @location.doors.build
    room = @location.rooms.build
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render action: 'show', status: :created, location: @location }
      else
        format.html { render action: 'new' }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy_all
    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:name, :max_cap, :site_url, :yelp_url, :current_state,:user_id,:address, :city, :state, :country, :postal_code, :user_id, :is_active, :longitude, :latitude)
    end
end
