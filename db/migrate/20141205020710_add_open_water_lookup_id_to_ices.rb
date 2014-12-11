class AddOpenWaterLookupIdToIces < ActiveRecord::Migration
  def change
    add_column :ices, :open_water_lookup_id, :integer
    add_column :ices, :thick_ice_lookup_id, :integer
    add_column :ices, :thin_ice_lookup_id, :integer
  end
end
