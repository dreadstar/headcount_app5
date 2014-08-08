class UserLocationFav < ActiveRecord::Base
	belongs_to :location  # foreign key - programmer_id
  belongs_to :user 
end
