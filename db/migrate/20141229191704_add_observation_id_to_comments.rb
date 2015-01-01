class AddObservationIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :observation_id, :integer
  end
end
