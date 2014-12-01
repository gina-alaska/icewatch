class CreateTopographies < ActiveRecord::Migration
  def change
    create_table :topographies do |t|
      t.integer :ice_observation_id
      t.boolean :old
      t.boolean :snow_covered
      t.integer :concentration
      t.integer :ridge_height
      t.integer :topography_lookup_id

      t.timestamps
    end
  end
end
