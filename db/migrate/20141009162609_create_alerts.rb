class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :msg
      t.string :url
      t.datetime :date_start
      t.datetime :date_end
      t.references :location, index: true

      t.timestamps
    end
  end
end
