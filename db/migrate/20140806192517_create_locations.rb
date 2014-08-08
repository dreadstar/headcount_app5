class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :user_id
      t.string :name
      t.integer :max_cap
      t.string :yelp_url
      t.string :site_url
      t.integer :current_state
      t.boolean :is_active

      t.timestamps
    end
  end
end
