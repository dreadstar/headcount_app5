class RoomSerializer < ActiveModel::Serializer
  attributes :id, :location_id, :name, :max_cap, :current_state
end
