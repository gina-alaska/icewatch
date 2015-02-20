module CruisesHelper
  def active_cruise(cruise)
    @active_cruise == cruise ? 'list-group-item-info' : ''
  end

  def ymd(date)
    date.try(:strftime, '%Y-%m-%d') || nil
  end
end
