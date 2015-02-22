class Location < ActiveRecord::Base
	cattr_accessor :realtime_user_id
	has_many :rooms
	has_many :doors # , after_add: :update_counter
	has_many :user_location_favs
	# has_many :users, through: :user_location_favs
	has_many :alerts

	after_create {|location| location.message 'create' }
  after_update {|location| location.message 'update' }
  after_destroy {|location| location.message 'destroy' }
  after_commit {|location| location.message 'update' }

  # acts_as_mappable
  geocoded_by :complete_address
  after_validation :geocode, :if => :check_address_changed? #, :on => :create



  def complete_address
  	"#{self.address}, #{self.city}, #{self.state}, #{self.postal_code}"
  end
	def update_state
		# sum of all doo
		new_current_state=0
		self.doors.each do |door|
			if door.is_external?
				new_current_state=new_current_state + door.current_state
			end
		end
		self.update_attributes(:current_state => new_current_state)
		logger.debug "location hash: #{self.inspect}"
		logger.info "location update_counter"
	end
  def message action
    msg = { resource: 'locations',
            action: action,
            id: self.id,
            obj: self }

    # $redis.publish 'rt-change', msg.to_json
    obj= {msg: msg,
    	recipient_user_ids: [41, 42 ]}
    #		recipient_user_ids: [41, Location.realtime_user_id ]}
		logger.debug "redis-config ENV : #{ENV.inspect}"
    logger.debug "message hash: #{obj.inspect}"
		logger.info "redis messaging"
    # $redis.publish 'realtime_msg', msg.to_json
    # $redis.publish 'rt-locations', obj.to_json
    $redis.publish 'realtime_msg', obj.to_json
  end


	accepts_nested_attributes_for :rooms, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
	accepts_nested_attributes_for :doors, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
	private
    def check_address_changed?
      :address_changed? || :postal_code_changed? || :city_changed? || :state_changed?
    end
  # def geocode_address
  #   geo=Geokit::Geocoders::MultiGeocoder.geocode (complete_address)
  #   errors.add(:complete_address, "Could not Geocode address") if !geo.success
  #   self.lat, self.lng = geo.lat,geo.lng if geo.success
  # end
end
