class RenameMeteorologyFields < ActiveRecord::Migration
  def change
    rename_column :meteorologies, :realtive_humidity, :relative_humidity
  end
end
