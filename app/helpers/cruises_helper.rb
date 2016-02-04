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

  def ogre_url
    Rails.application.secrets.ogre_url
  end

  def list_group_item_for(data, label)
    return if data.nil?
    content_tag(:li, '', class: 'list-group-item') do
      concat(content_tag(:strong, label))
      concat(data)
    end
  end
end
