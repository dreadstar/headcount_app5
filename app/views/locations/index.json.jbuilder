json.array!(@locations) do |location|
  json.extract! location, :id, :user_id, :name, :max_cap, :yelp_url, :site_url, :current_state, :is_active
  json.url location_url(location, format: :json)
end
