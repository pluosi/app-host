class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    if user.admin?
        can :manage, :all

        cannot :manage, User

        can :update, User do |user,current_user|
          current_user.admin?
        end

        can :destroy, User do |user,current_user|
          current_user.admin? && user.id != current_user.id
        end

        can :create, User
        
    else
        can :read, :all
        if user.persisted? 
          can :manage, App, :user_id => user.id
          
          # can :manage, Plat, :user_id => user.id
          # can :manage, Pkg, :user_id => user.id 
          
          can :manage, Plat do |plat|
            plat.user_id == user.id || plat.app.user_id == user.id
          end

          can :manage, Pkg do |pkg|
            pkg.user_id == user.id || pkg.plat.user_id == user.id || pkg.app.user_id == user.id
          end

          if user.editor?
            can :sort, Plat
          end


        end
    end
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
