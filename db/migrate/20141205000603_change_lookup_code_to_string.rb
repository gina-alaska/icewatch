class ChangeLookupCodeToString < ActiveRecord::Migration
  def up
    change_column :lookups, :code, :string
  end
end
