class DoormsgsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_doormsg, only: [:show, :edit, :update, :destroy]

  # GET /doormsgs
  # GET /doormsgs.json
  def index
    @doormsgs = Doormsg.all
  end

  # GET /doormsgs/1
  # GET /doormsgs/1.json
  def show
  end

  # GET /doormsgs/new
  def new
    @doormsg = Doormsg.new
  end

  # GET /doormsgs/1/edit
  def edit
  end

  # POST /doormsgs
  # POST /doormsgs.json
  def create
    @doormsg = Doormsg.new(doormsg_params)

    respond_to do |format|
      if @doormsg.save
        format.html { redirect_to @doormsg, notice: 'Doormsg was successfully created.' }
        format.json { render :show, status: :created, location: @doormsg }
      else
        format.html { render :new }
        format.json { render json: @doormsg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doormsgs/1
  # PATCH/PUT /doormsgs/1.json
  def update
    respond_to do |format|
      if @doormsg.update(doormsg_params)
        format.html { redirect_to @doormsg, notice: 'Doormsg was successfully updated.' }
        format.json { render :show, status: :ok, location: @doormsg }
      else
        format.html { render :edit }
        format.json { render json: @doormsg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doormsgs/1
  # DELETE /doormsgs/1.json
  def destroy
    @doormsg.destroy
    respond_to do |format|
      format.html { redirect_to doormsgs_url, notice: 'Doormsg was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doormsg
      @doormsg = Doormsg.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doormsg_params
      # params.require(:doormsg).permit(:door_id, :tstamp, :msg, :sensor_id, :counter_state, :ip_addr)
      params.require(:doormsg).permit(:door_id, :tstamp, :msg, :sensor_id, :counter_state, :ip_addr)
    end
end
