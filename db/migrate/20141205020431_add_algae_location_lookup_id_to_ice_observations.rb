class AddAlgaeLocationLookupIdToIceObservations < ActiveRecord::Migration
  def change
    add_column :ice_observations, :algae_location_lookup_id, :integer
  end
end
