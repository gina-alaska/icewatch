class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.integer :cruise_id
      t.datetime :observed_at
      t.float :latitude
      t.float :longitude
      t.string :uuid
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
