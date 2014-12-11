class AddAdditionalFieldsToLookups < ActiveRecord::Migration
  def change
    add_column :lookups, :height, :string
    add_column :lookups, :group, :string
  end
end
