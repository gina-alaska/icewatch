module PrimaryObserver
  extend ActiveSupport::Concern

  attr_writer :primary_observer_id_or_name

  included do
    before_save :resolve_primary_observer
  end

  def resolve_primary_observer
    self.primary_observer = resolve_observer(@primary_observer_id_or_name) unless @primary_observer_id_or_name.blank?
  end

  def primary_observer_id_or_name
    primary_observer.try(:id)
  end

  def resolve_observer(id_or_name)
    Person.find_or_create_by_id_or_name(id_or_name)
  end
end
