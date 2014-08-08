class DoorSerializer < ActiveModel::Serializer
  attributes :id, :location_id, :name, :flow_from, :sensor_id, :current_state, :flow_to, :is_external
end
