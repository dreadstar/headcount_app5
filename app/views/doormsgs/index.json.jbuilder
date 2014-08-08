json.array!(@doormsgs) do |doormsg|
  json.extract! doormsg, :id, :door_id, :tstamp, :msg, :sensor_id, :counter_state, :ip_addr
  json.url doormsg_url(doormsg, format: :json)
end
