module IceObservationsHelper
  def ice_without_floe_size
    IceLookup.where(code: [10,11,12,13,90]).pluck(:id)
  end
end
