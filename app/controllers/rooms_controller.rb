class RoomsController < ApplicationController
	
  before_action :find_location, except: [:index, :show]
  before_action :find_room, only: [ :update, :destroy]

  def new
    @room = Room.new
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    if @room.update(rooms_params)
      redirect_to location_path(@location), notice: 'Room was successfully updated.'
    else
      render :edit
    end
  end

  def create
    @room = Room.new(rooms_params.merge(location_id: @location.id))

    if @room.save
      redirect_to location_path(@location), notice: 'Room was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @room.destroy
    flash[:notice] = 'Room was successfully deleted'
    redirect_to location_path(@location)
  end

  private

  def rooms_params
    params.require(:room).permit( :name, :current_state, :max_cap)
  end

  def find_room
    @room = Room.find(params[:id])
  end

  def find_location
    @location ||= Location.find(params[:location_id])
  end


 
end
