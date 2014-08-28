class Room < ActiveRecord::Base
	belongs_to :location
	has_many :doors_out, foreign_key: :flow_from, class_name: 'Door'
	has_many :doors_in,  foreign_key: :flow_to, class_name: 'Door'

	def update_state
		# sum of all doo
		new_current_state=0
		self.doors_in.limit(100)
		self.doors_out.limit(100)
		self.doors_in.find_each do |door|
			new_current_state=new_current_state +door.current_state	
			logger.info "room doors_in : #{door.current_state}"
		end
		self.doors_out.find_each do |door|
			new_current_state=new_current_state - door.current_state	
			logger.info "room doors_out : #{door.current_state}"
		end
		self.update_attributes(:current_state => new_current_state)
		logger.debug "room hash: #{self.inspect}"
		logger.info "room update_counter"
	end
end
