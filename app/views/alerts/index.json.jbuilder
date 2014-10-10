json.array!(@alerts) do |alert|
  json.extract! alert, :id, :location_id, :msg, :url,:date_start,:date_end, :created_at, :updated_at
  json.url alert_url(alert, format: :json)
end
