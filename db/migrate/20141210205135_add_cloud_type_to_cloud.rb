class AddCloudTypeToCloud < ActiveRecord::Migration
  def change
    add_column :clouds, :cloud_type, :string
  end
end
