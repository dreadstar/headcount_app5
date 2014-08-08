class CreateUserLocationFavs < ActiveRecord::Migration
  def change
    create_table :user_location_favs do |t|
      t.integer :user_id
      t.integer :location_id
      t.datetime :tstamp

      t.timestamps
    end
  end
end
