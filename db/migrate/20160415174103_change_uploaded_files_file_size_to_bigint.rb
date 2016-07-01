class ChangeUploadedFilesFileSizeToBigint < ActiveRecord::Migration
  def change
    change_column :uploaded_files, :file_size, :bigint
  end
end
