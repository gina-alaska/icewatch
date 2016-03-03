class AddAdditionlMetadatToUploadedPhotoset < ActiveRecord::Migration
  def change
    add_column :uploaded_photosets, :file_filename, :string
    add_column :uploaded_photosets, :file_size, :integer
    add_column :uploaded_photosets, :file_content_type, :string
  end
end
