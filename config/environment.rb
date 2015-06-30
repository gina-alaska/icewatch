# Load the Rails application.
require File.expand_path('../application', __FILE__)

if RUBY_PLATFORM == 'java'
  EXPORT_PATH = java.lang.System.getProperty('export') || 'public'
else
  EXPORT_PATH = 'public'
end

# Initialize the Rails application.
Rails.application.initialize!
