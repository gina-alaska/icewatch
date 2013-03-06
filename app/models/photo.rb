class Photo
  include Mongoid::Document

  field :photo_uid
  field :preview_uid
  field :photo_name
  field :checksum_id, type: String
  field :note, type: String
  field :observation_id
  field :cruise_id
  
  file_accessor :photo do |a|
    copy_to(:preview) do |a|
      a.encode(:jpg).thumb('240x160')
    end
  end
  file_accessor :preview do |a|
    after_assign { |a| a.name = "#{a.basename}.jpg" }
  end

  belongs_to :observation
  belongs_to :cruise
  belongs_to :on_boat_location_lookup
  
end