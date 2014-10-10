class Alert < ActiveRecord::Base
  belongs_to :location
  after_create {|alert| alert.message 'create' }

  def message action
    msg = { resource: 'alerts',
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
    # $redis.publish 'rt-locations', obj.to_json
    $redis.publish 'realtime_msg', obj.to_json
  end
end
