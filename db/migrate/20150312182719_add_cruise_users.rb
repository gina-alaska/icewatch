class AddCruiseUsers < ActiveRecord::Migration
  def change
    create_table :cruises_users do |t|
      t.integer :cruise_id
      t.integer :user_id

      t.timestamps
    end
  end
end
