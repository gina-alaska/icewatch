class AddRefileToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :file_id, :string
    add_column :photos, :file_filename, :string
    add_column :photos, :file_content_type, :string
    add_column :photos, :file_size, :integer
  end
end
