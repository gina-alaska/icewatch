class Meteorology
  include Mongoid::Document

  embedded_in :observation
end