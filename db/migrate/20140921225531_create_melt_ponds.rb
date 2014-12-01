class CreateMeltPonds < ActiveRecord::Migration
  def change
    create_table :melt_ponds do |t|
      t.integer :ice_observation_id
      t.integer :max_depth_lookup_id
      t.integer :surface_lookup_id
      t.integer :pattern_lookup_id
      t.integer :bottom_type_lookup_id
      t.integer :surface_coverage
      t.integer :freeboard
      t.boolean :dried_ice
      t.boolean :rotten_ice

      t.timestamps
    end
  end
end
