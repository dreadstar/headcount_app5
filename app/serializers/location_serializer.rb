class LocationSerializer < ActiveModel::Serializer
	embed :ids, include: true
#  def id
#    object.id.to_s
#  end
  def fanscnt
  	object.users.size
  end
  def current_state
 	  if !object.current_state?
 		  0
 	  else
 	 	  object.current_state
 	  end
  end
  def max_cap
 	  if !object.max_cap?
 		  1
    else
   	  object.max_cap
 	  end
  end


  attributes :id, :name, :max_cap, :current_state, :yelp_url, :site_url, :fanscnt
  # has_many :userlocationfavs, embed: :ids
  # has_many :doors
  # has_many :user_location_favs
  # has_many :users
  
end
