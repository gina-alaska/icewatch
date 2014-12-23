class AddStatusToObservation < ActiveRecord::Migration
  def change
    add_column :observations, :status, :string
  end
end
