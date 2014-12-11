class AddConsolidatedToTopographies < ActiveRecord::Migration
  def change
    add_column :topographies, :consolidated, :boolean
  end
end
