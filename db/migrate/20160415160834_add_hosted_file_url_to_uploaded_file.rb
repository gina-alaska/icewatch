class AddHostedFileUrlToUploadedFile < ActiveRecord::Migration
  def change
    add_column :uploaded_files, :hosted_file_url, :string
  end
end
