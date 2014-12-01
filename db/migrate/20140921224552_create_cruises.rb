class CreateCruises < ActiveRecord::Migration
  def change
    create_table :cruises do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :objective
      t.boolean :approved
      t.integer :ship_id

      t.timestamps
    end
  end
end
