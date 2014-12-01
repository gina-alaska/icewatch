class CreateIces < ActiveRecord::Migration
  def change
    create_table :ices do |t|
      t.integer :observation_id
      t.integer :total_concentration

      t.timestamps
    end
  end
end
