class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :location_id
      t.string :name
      t.integer :max_cap
      t.integer :current_state

      t.timestamps
    end
  end
end
