class AddPeopleToCruise < ActiveRecord::Migration
  def change
    add_column :cruises, :chief_scientist, :string
    add_column :cruises, :captain, :string
    add_column :cruises, :primary_observer, :string
    add_column :cruises, :name, :string
    add_column :cruises, :ship, :string
    add_column :cruises, :archived, :boolean, default: false
  end
end
