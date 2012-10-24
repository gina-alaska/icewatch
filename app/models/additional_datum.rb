class AdditionalDatum
  include Mongoid::Document

  embedded_in :observation
end