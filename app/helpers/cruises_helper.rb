module CruisesHelper
  def active_cruise(cruise)
    @active_cruise == cruise ? 'list-group-item-info' : ''
  end

  def ymd(date)
    date.try(:strftime, '%Y-%m-%d') || nil
  end

  def cruise_highlight(cruise)
    cruise.approved? ? '' : 'list-group-item-warning'
  end

  def cruise_lock_state(cruise)
    cruise.locked? ? 'unlock' : 'lock'
  end
end
