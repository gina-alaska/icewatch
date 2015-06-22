class RemoveApprovedFromObservation < ActiveRecord::Migration
  def up
    Observation.all.each do |obs|
      if obs.approved? and !obs.status == 'accepted'
        obs.accept! if obs.valid?
      end

      if !obs.approved? and !obs.status == 'saved'
        obs.assign_attribute(:status, 'saved')
        obs.save(validate: false)
      end
    end

    remove_column :observations, :approved
  end

  def down
    add_column :observations, :approved, :boolean, default: false

    Observation.all.each do |obs|
      obs.approved = obs.accepted?
      obs.save
    end
  end
end
