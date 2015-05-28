class AddPrimaryObserverIdToCruise < ActiveRecord::Migration
  def up
    add_column :cruises, :primary_observer_id, :integer

    Cruise.all.each do |cruise|
      person = Person.where(name: cruise['primary_observer']).first_or_create
      cruise.primary_observer_id = person.id
      cruise.save!
    end

    remove_column :cruises, :primary_observer
  end

  def down
    add_column :cruises, :primary_observer, :string

    Cruise.all.each do |cruise|
      cruise['primary_observer'] = c.primary_observer.try(&:name)
      cruise.save!
    end

    remove_column :cruises, :primary_observer_id
  end
end
