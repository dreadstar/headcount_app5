class DoorsController < ApplicationController
	before_action :find_location, only: [:new, :edit, :create, :update, :destroy, :show]	
  before_action :find_door, only: [:update, :destroy]

  def show
    @door = Door.find(params[:id])
    @room_in= Room.find(@door.flow_to)
    if !@door.is_external then
      @room_out= Room.find(@door.flow_from)
    end
  end

  def new
    @door = Door.new
  end

  def edit
    @door = Door.find(params[:id])
    @rooms= @location.rooms
  end

  def update
    if @door.update(doors_params)
      redirect_to location_path(@location), notice: 'Door was successfully updated.'
    else
      render :edit
    end
  end

  def create
    @door = Door.new(doors_params.merge(location_id: @location.id))

    if @door.save
      redirect_to location_path(@location), notice: 'Door was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @door.destroy
    flash[:notice] = 'Door was successfully deleted'
    redirect_to location_path(@location)
  end

  private

  def doors_params
    params.require(:door).permit( :name, :is_external, :flow_to, :flow_from, :sensor_id, :current_state)
    # need to add sensor_id and cusotmize model has many for vusomt sql
  end


  def find_door
    @door = Door.find(params[:id])
  end

  def find_location
    @location ||= Location.find(params[:location_id])
  end
  def find_room_in
    @room_in ||= Room.find(params[:flow_to])
  end
  def find_room_out
    @room_out ||= Room.find(params[:flow_from])
  end
end
