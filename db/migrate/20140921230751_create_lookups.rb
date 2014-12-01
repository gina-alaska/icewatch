class CreateLookups < ActiveRecord::Migration
  def change
    create_table :lookups do |t|
      t.integer :code
      t.string :name
      t.string :type
      t.string :comment

      t.timestamps
    end
  end
end
