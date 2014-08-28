class Door < ActiveRecord::Base
	belongs_to :location
	has_many :doormsgs,  foreign_key: :sensor_id, primary_key: :sensor_id
	belongs_to :rooms_to,  foreign_key: :flow_to, class_name: 'Room'
	belongs_to :rooms_from,  foreign_key: :flow_from, class_name: 'Room'
	after_commit :update_state

	def update_state
		self.location.update_state
		self.rooms_to.update_state
		self.rooms_from.update_state
		
		logger.info "door update_counter"
	end

end
