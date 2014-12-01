class CreateClouds < ActiveRecord::Migration
  def change
    create_table :clouds do |t|
      t.integer :meteorology_id
      t.integer :cloud_lookup_id
      t.integer :cover
      t.integer :height
      t.string  :type

      t.timestamps
    end
  end
end
