class Cloud < ActiveRecord::Base
  belongs_to :meteorology
  belongs_to :cloud_lookup
end
