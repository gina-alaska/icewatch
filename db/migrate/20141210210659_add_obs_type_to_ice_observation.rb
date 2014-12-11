class AddObsTypeToIceObservation < ActiveRecord::Migration
  def change
    add_column :ice_observations, :obs_type, :string
  end
end
