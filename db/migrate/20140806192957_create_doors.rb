class CreateDoors < ActiveRecord::Migration
  def change
    create_table :doors do |t|
      t.integer :location_id
      t.string :name
      t.integer :flow_from
      t.string :sensor_id
      t.integer :current_state
      t.integer :flow_to
      t.boolean :is_external

      t.timestamps
    end
  end
end
