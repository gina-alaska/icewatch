class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.integer :heading
      t.integer :power
      t.integer :speed
      t.integer :ship_activity_lookup_id
      t.integer :observation_id

      t.timestamps
    end
  end
end
