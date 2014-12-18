module CruisesHelper
  def active_cruise(cruise)
    @active_cruise == cruise ? 'list-group-item-info' : ''
  end
end
