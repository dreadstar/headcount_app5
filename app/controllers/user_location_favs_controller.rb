class UserLocationFavsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_userlocationfav, only: [:show, :edit, :update, :destroy]

  # GET /doormsgs
  # GET /doormsgs.json
  def index
    @userlocationfavs = UserLocationFav.where( user_id: current_user.id)
    logger.debug "user location: #{@userlocationfavs}"
  end

  # GET /doormsgs/1
  # GET /doormsgs/1.json
  def show
  end

  # GET /doormsgs/new
  def new
    @userlocationfav = UserLocationFav.new
  end

  # GET /doormsgs/1/edit
  def edit
  end

  # POST /doormsgs
  # POST /doormsgs.json
  def create
    @userlocationfav = UserLocationFav.new(userlocationfav_params)
     @userlocationfav.user_id = current_user.id if current_user
    # @userlocationfav.user_id = 666

    respond_to do |format|
      if current_user
        if @userlocationfav.save
          format.html { redirect_to @userlocationfav, notice: 'UserLocationFav was successfully created.' }
          format.json { render :show, status: :created, location: @userlocationfav }
        else
          format.html { render :new }
          format.json { render json: @userlocationfav.errors, status: :unprocessable_entity }
        end
      else
        render :json => {:errors => 'Login in to Save Favorites'}
      end
    end
  end

  # PATCH/PUT /doormsgs/1
  # PATCH/PUT /doormsgs/1.json
  def update
    respond_to do |format|
      if @userlocationfav.update(userlocationfav_params)
        format.html { redirect_to @userlocationfav, notice: 'Userlocationfav was successfully updated.' }
        format.json { render :show, status: :ok, location: @userlocationfav }
      else
        format.html { render :edit }
        format.json { render json: @userlocationfav.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doormsgs/1
  # DELETE /doormsgs/1.json
  def destroy
    logger.debug "user locationfav destroy: #{@userlocationfav}"
    @userlocationfav.destroy
    respond_to do |format|
      format.html { redirect_to user_location_favs_url, notice: 'Userlocationfav was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_userlocationfav
      @userlocationfav = UserLocationFav.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def userlocationfav_params
      # params.require(:doormsg).permit(:door_id, :tstamp, :msg, :sensor_id, :counter_state, :ip_addr)
      # figre out ay to insert user_id to parameters
      params.require(:user_location_fav).permit(:id, :location_id)
    
    
  end
end
