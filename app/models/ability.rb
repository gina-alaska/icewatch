class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    #if assist?
      can :manage, :all
    #else  #IceWatch
      if user.role? :admin
        can :manage, :all
        # Admins can promote users to managers or admins
        # Admins can unlock Cruises
        # Admins can unlock Observations
        # Admins can perform manager actions
      end

      if user.role? :manager
        # Managers can approve Cruises
        # Managers can approve Observations
        # Managers can lock Cruises
        # Managers can lock Observations
        # Managers can modify Observations if they aren't locked
        # Managers can promote users to members
        # Managers can perform member actions
      end

      if user.role? :member
        # Members can create cruises
        # Members can upload observations
        # Members can perform guest actions
      end

      if user.role? :guest
        # Guests can download assist
        # Guests can download data
        # Registered guests can request member access
      end
    #end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
