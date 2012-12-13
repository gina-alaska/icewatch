class ImportWorker
  include Sidekiq::Worker
  
  def perform uploaded_observation_id
    # uploaded_obs = UploadedObservation.where(id: uploaded_observation_id).first
    # 
    # imports = ImportObservation.new(file: uploaded_obs.observations.path, cruise_id: uploaded_obs.cruise_id)
    # 
    # if imports.save
    #   uploaded_obs.destroy
    # else
    #   uploaded_obs.errors = imports.errors.serialize
    #   uplaoded_obs.save
    # end    
  end
end