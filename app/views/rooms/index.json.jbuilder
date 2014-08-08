json.array!(@rooms) do |room|
  json.extract! room, :id, :location_id, :name, :max_cap, :current_state
  json.url room_url(room, format: :json)
end
