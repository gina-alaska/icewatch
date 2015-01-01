class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :observation_id
      t.integer :on_boat_location_lookup_id
      t.string :name
      t.string :checksum_id
      t.string :note

      t.timestamps
    end
  end
end
