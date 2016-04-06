class ImportFileJob < ActiveJob::Base
  queue_as :default

  def perform(uploaded_file)
    uploaded_file.copy_to_photo
    # uploaded_file.destroy
  end

end
