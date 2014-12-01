class CreateFaunas < ActiveRecord::Migration
  def change
    create_table :faunas do |t|
      t.string :name
      t.integer :count
      t.integer :observation_id

      t.timestamps
    end
  end
end
