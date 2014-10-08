json.array!(@userlocationfavs) do |userlocationfav|
  json.extract! userlocationfav, :id, :user_id, :location_id, :created_at, :updated_at
  json.url user_location_fav_url(userlocationfav, format: :json)
end
