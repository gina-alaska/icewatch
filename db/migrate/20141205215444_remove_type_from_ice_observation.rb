class RemoveTypeFromIceObservation < ActiveRecord::Migration
  def change
    remove_column :ice_observations, :type
  end
end
