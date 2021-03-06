class UserInvitations::MarkAsComplete
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    invitation = UserInvitation.find_by_email(@user[:email].downcase)
    return if invitation.blank?

    Audited.audit_class.as_user(@user) { invitation.update(invitee: @user) }

    UserInvitations::NotifyInviterOfCompletion.call(@user)
  end
end
