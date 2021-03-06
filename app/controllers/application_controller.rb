class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protected


  def set_realtime_user_id
    #  set @current_account from session data here
    Location.realtime_user_id = realtime_user_id
  end

  # code added for realtime integration
  realtime_controller
  def realtime_user_id
    # return !user_signed_in? ? 42 : current_user.user_id
    return 42
  end
  def realtime_server_url
    if Rails.env.development?
      return 'http://localhost:5001'
      # return 'http://192.168.1.2:5001'
      # return 'http://192.168.1.2:5001'
    end
    if Rails.env.production?
      return 'https://arcane-tundra-4360.herokuapp.com'
    end
  end


  def after_sign_in_path_for(resource)
    # return the path based on resource
    if admin_signed_in?
    	admin_index_path
    else
    	welcome_index_path
    end

  end
end
