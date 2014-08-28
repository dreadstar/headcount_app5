class Door < ActiveRecord::Base
	belongs_to :location
	has_many :doormsgs,  foreign_key: :sensor_id, primary_key: :sensor_id

	after_commit :update_state

	def update_state
		self.location.update_state
		
		logger.info "door update_counter"
	end

end
