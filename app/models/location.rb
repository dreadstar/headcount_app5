class Location < ActiveRecord::Base
	has_many :rooms
	has_many :doors
	has_many :user_location_favs
	has_many :users, through: :user_location_favs 

	accepts_nested_attributes_for :rooms, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
	accepts_nested_attributes_for :doors, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
end
