class CreateMeteorologies < ActiveRecord::Migration
  def change
    create_table :meteorologies do |t|
      t.integer :observation_id
      t.integer :weather_lookup_id
      t.integer :visibility_lookup_id
      t.integer :total_cloud_cover
      t.integer :wind_speed
      t.string :wind_direction
      t.float :air_temperature
      t.float :water_temperature
      t.integer :realtive_humidity
      t.integer :air_pressure

      t.timestamps
    end
  end
end
