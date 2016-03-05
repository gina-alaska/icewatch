# Load the Rails application.
require File.expand_path('../application', __FILE__)

EXPORT_PATH = if RUBY_PLATFORM == 'java'
  (java.lang.System.getProperty('export') || 'public').freeze
else
  'public'.freeze
end

# Initialize the Rails application.
Rails.application.initialize!
