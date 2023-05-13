class Ability
  include CanCan::Ability

  # Define abilities for any given user
  # Philosphy: keep this as simple as possible
  #
  #   1. Stick with `:read` and `:write` where possible, even if the phrasing
  #      is awkward (e.g. "edit user" sometimes reads better than "write user")
  #
  #   2. Avoid using `:manage` and `:all` where possible. It's a catch-all, and
  #      not a best-practice
  #
  #   3. Define by ability, not by role
  def initialize(user)
    @user = user

    can :read, :mailer_previews do
      leader?
    end

    can :write, :sidekiq do
      leader?
    end

    can :read, :users do
      true
    end

    can :read, User do |_u|
      leader?
    end

    can :write, User do |_user|
      leader?
    end

    can :read, :user_invitations do
      leader?
    end

    can :write, UserInvitation do |_user_invitation|
      leader?
    end

    can :create, :user_invitations do
      leader?
    end
  end

  def user_abilities_for(subject)
    user = subject.is_a?(UserPresenter) ? subject.model : subject

    { read: can?(:read, user), write: can?(:write, user) }
  end

  private

  def leader?
    @user.has_role?(:leader)
  end
end
