class AlertsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_alert, only: [:show, :edit, :update, :destroy]
  before_action :find_location, only: [:index, :new, :edit, :create, :update, :destroy, :show]

  # GET /doormsgs
  # GET /doormsgs.json
  def index
    if params[:location_id]
      @alerts = Alert.where(location_id: params[:location_id])
    else
      @alerts = Alert.where("date_start < :now and date_end > :now" ,{now: DateTime.current()})
    end
    logger.debug "get alert list: #{@alerts}"
  end

  
  # GET /doormsgs/1
  # GET /doormsgs/1.json
  def show
  end

  # GET /doormsgs/new
  def new
    logger.debug "get locationt: #{@location}"
    @alert = Alert.new
  end

  # GET /doormsgs/1/edit
  def edit
  end

  # POST /doormsgs
  # POST /doormsgs.json
  def create
    @alert = Alert.new(alert_params.merge(location_id: @location.id))
     
    # @alert.user_id = 666

    if @alert.save
      redirect_to location_path(@location), notice: 'Alert was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /doormsgs/1
  # PATCH/PUT /doormsgs/1.json
  def update
    if @alert.update(alert_params)
      redirect_to location_path(@location), notice: 'Alert was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /doormsgs/1
  # DELETE /doormsgs/1.json
  def destroy
    @alert.destroy
    flash[:notice] = 'Alert was successfully deleted'
    redirect_to location_path(@location)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alert
      @alert = Alert.find(params[:id])
    end
    def find_location
      if params[:location_id]
        @location ||= Location.find(params[:location_id])
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def alert_params
      # params.require(:doormsg).permit(:door_id, :tstamp, :msg, :sensor_id, :counter_state, :ip_addr)
      # figre out ay to insert user_id to parameters
      params.require(:alert).permit(:id, :location_id,:msg, :url, :date_end, :date_start)
    
    
  end
end
