class Doormsg < ActiveRecord::Base
	belongs_to :door, foreign_key: :sensor_id, primary_key: :id
end
