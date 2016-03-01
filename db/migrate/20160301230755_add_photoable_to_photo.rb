class AddPhotoableToPhoto < ActiveRecord::Migration
  def change
    add_reference :photos, :photoable, polymorphic: true, index: true
    Photo.find_each do |photo|
      unless photo.observation_id.nil?
        photo.update_attribute(photoable_id: photo.observation_id,
                               photoable_type: 'Observation')
      end
    end
    remove_column :photos, :observation_id
  end
end
