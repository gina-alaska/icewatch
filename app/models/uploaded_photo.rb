class UploadedPhoto
  include Mongoid::Document
  
  field :file_uid
  field :cruise_id
  field :file_name
  file_accessor :file
  
  def taken_at
    begin
      DateTime.strptime(file_name,"%Y%m%d%H%M")
    rescue
      nil
    end
  end
end