class CreateIceObservations < ActiveRecord::Migration
  def change
    create_table :ice_observations do |t|
      t.integer :observation_id
      t.integer :floe_size_lookup_id
      t.integer :snow_lookup_id
      t.integer :ice_lookup_id
      t.integer :algae_lookup_id
      t.integer :algae_density_lookup_id
      t.integer :algae_density_lookup_id
      t.integer :sediment_lookup_id
      t.integer :partial_concentration
      t.integer :thickness
      t.integer :snow_thickness
      t.string  :type  

      t.timestamps
    end
  end
end
