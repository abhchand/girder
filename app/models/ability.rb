class Ability
  include CanCan::Ability

  # Define abilities for any given user
  # Philosphy: keep this as simple as possible
  #
  #   1. Stick with rails verbs - `:index`, `:show`, `:create`, etc...
  #
  #   2. Avoid using `:manage` and `:all` where possible. It's a catch-all, and
  #      not a best-practice
  #
  #   3. Define by ability, not by role
  def initialize(user)
    @user = user

    #
    # Users
    #

    can :index, :users do
      true
    end

    can :show, User do |_u|
      leader?
    end

    can :update, User do |user|
      leader? || @user == user
    end

    can :destroy, User do |user|
      leader? || @user == user
    end

    can :update_role, User do |user|
      leader?
    end

    #
    # UserInvitation
    #

    can :index, :user_invitations do
      leader?
    end

    can :create, :user_invitation do
      leader?
    end

    can :destroy, UserInvitation do |_user_invitation|
      leader?
    end

    #
    # Misc
    #

    can :read, :mailer_previews do
      leader?
    end

    can :write, :sidekiq do
      leader?
    end
  end

  private

  def admin?(family, user)
    family_role_for(family, user) == :admin
  end

  def family_role_for(family, user)
    FamilyService.new(family).role_for(user)
  end

  def leader?
    @user.has_role?(:leader)
  end
end
