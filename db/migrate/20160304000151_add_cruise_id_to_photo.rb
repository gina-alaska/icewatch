class AddCruiseIdToPhoto < ActiveRecord::Migration
  def change
    add_reference :photos, :cruise, index: true, foreign_key: true
  end
end
