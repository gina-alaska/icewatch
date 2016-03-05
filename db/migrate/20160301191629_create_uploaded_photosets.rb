class CreateUploadedPhotosets < ActiveRecord::Migration
  def change
    create_table :uploaded_photosets do |t|
      t.string :file_id
      t.integer :cruise_id

      t.timestamps null: false
    end
  end
end
