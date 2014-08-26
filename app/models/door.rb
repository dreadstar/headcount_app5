class Door < ActiveRecord::Base
	belongs_to :location
	has_many :doormsgs,  foreign_key: :sensor_id, primary_key: :sensor_id, after_add: :update_counter


	def update_counter(doormsg)
		new_current_state=doormsg.counter_state + self.current_state
		self.update_attributes(:current_state => new_current_state)
		logger.debug "door hash: #{self.inspect}"
		logger.info "door update_counter"
	end
end
