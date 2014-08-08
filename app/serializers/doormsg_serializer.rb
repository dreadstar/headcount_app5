class DoormsgSerializer < ActiveModel::Serializer
  attributes :id, :door_id, :tstamp, :msg, :sensor_id, :counter_state, :ip_addr
end
