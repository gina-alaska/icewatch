class CreatePersonObservations < ActiveRecord::Migration
  def change
    create_table :person_observations do |t|
      t.boolean :primary
      t.integer :observation_id
      t.integer :person_id

      t.timestamps
    end
  end
end
