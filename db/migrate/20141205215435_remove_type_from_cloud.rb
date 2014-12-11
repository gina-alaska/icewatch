class RemoveTypeFromCloud < ActiveRecord::Migration
  def change
    remove_column :clouds, :type
  end
end
