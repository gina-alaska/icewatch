class RenameUploadedPhotosetToUploadedFile < ActiveRecord::Migration
  def change
    rename_table :uploaded_photosets, :uploaded_files
  end
end
