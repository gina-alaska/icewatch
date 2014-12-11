class ChangeTopographyRidgeHeightToFloat < ActiveRecord::Migration
  def up
    change_column :topographies, :ridge_height, :float
  end

  def down
    change_column :topographies, :ridge_height, :integer
  end
end
