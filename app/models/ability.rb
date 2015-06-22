class Ability
  include CanCan::Ability

  def initialize(user)

    # if the user is defined then use it, otherwise instantiate it to an empty
    # user object: guest user
    user ||= User.new

    # this means the user who owns the question can do any action on the question
    # manage allows any action including :destroy, :edit, :update ..etc
    can :manage, Myidea do |myidea|
      # question.user == user || question.collaborations.each {|c| c.user == user}
      myidea.user == user
    end

  #  can :edit, Myidea do |myidea|
  #    myidea.collaborating_users.include?(user)
  #  end


    can :manage, Comment do |comment|
      comment.myidea.user == user || comment.user == user
    end

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
