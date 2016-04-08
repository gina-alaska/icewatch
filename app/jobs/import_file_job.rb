class ImportFileJob < ActiveJob::Base
  queue_as :default

  def perform(uploaded_file)
    uploaded_file.import!
  end

end
