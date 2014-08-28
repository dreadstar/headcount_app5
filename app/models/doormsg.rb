class Doormsg < ActiveRecord::Base
	belongs_to :door, foreign_key: :sensor_id, primary_key: :sensor_id
	after_commit :update_counter

	def update_counter
		new_current_state=self.counter_state + self.door.current_state
		self.door.update_attributes(:current_state => new_current_state)
		logger.debug "door hash: #{self.door.inspect}"
		logger.info "doormsg update_counter"
	end
end
