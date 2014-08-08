class Door < ActiveRecord::Base
	belongs_to :location
	has_many :doormsgs,  foreign_key: :sensor_id, primary_key: :sensor_id
end
