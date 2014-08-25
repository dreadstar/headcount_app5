class Location < ActiveRecord::Base
	cattr_accessor :realtime_user_id
	has_many :rooms
	has_many :doors
	has_many :user_location_favs
	has_many :users, through: :user_location_favs 

	after_create {|location| location.message 'create' }
  after_update {|location| location.message 'update' }
  after_destroy {|location| location.message 'destroy' }

  def message action
    msg = { resource: 'locations',
            action: action,
            id: self.id,
            obj: self }
    
    # $redis.publish 'rt-change', msg.to_json
    obj= {msg: msg,
    	recipient_user_ids: [41, 42 ]}
    #		recipient_user_ids: [41, Location.realtime_user_id ]}
    logger.debug "message hash: #{obj.inspect}"
		logger.info "redis messaging"
    # $redis.publish 'realtime_msg', msg.to_json
    $redis.publish 'rt-locations', obj.to_json
  end


	accepts_nested_attributes_for :rooms, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
	accepts_nested_attributes_for :doors, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
end
