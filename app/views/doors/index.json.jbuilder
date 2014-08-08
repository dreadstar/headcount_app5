json.array!(@doors) do |door|
  json.extract! door, :id, :location_id, :name, :flow_from, :sensor_id, :current_state, :flow_to, :is_external
  json.url door_url(door, format: :json)
end
