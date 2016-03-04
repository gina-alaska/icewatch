class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    # if assist?
    if assist?
      can :manage, :all
    end

    # else  #IceWatch
    if user.has_role? :admin
      can :manage, :all
      # Admins can promote users to managers or admins
      # Admins can unlock Cruises
      # Admins can unlock Observations
      # Admins can perform manager actions
    end

    if user.has_role? :manager
      can [:manage, :approve, :approve_observations], Cruise
      can [:manage, :approve, :edit], Observation
      can :create, UploadedPhotoset
      can :read, User
      # Managers can approve Cruises
      # Managers can approve Observations
      # Managers can lock Cruises
      # Managers can lock Observations
      # Managers can modify Observations if they aren't locked
      # Managers can promote users to members
      # Managers can perform member actions
    end

    if user.has_role? :member
      can :create, Cruise
      can :import, Cruise, id: user_cruises(user)
      can :import, Observation, cruise_id: user_cruises(user)
      can :read, Cruise, approved: true
      can :read, Cruise, id: user_cruises(user)
      can :read, Observation, status: 'accepted'
      can :read, User, id: user.id
      can :create, UploadedPhotoset, cruise_id: user_cruises(user)
      # Members can create cruises
      # Members can upload observations
      # Members can perform guest actions
    end

    if user.has_role? :guest
      can :read, Cruise, approved: true
      can :read, Observation, status: 'accepted'
      can :read, User, id: user.id
      # Guests can download assist
      # Guests can view and download data
      # Registered guests can request member access
    end
  end

  private

  def assist?
    RUBY_PLATFORM == 'java' || Rails.application.secrets.icewatch_assist == true
  end

  def user_cruises(user)
    user.cruises.map(&:id)
  end
end
