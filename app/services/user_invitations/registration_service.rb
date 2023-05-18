class UserInvitations::RegistrationService
  def self.call(invitee)
    new(invitee).call
  end

  def call
    return if user_invitation.blank?

    apply_roles
  end

  private

  def initialize(invitee)
    @invitee = invitee
  end

  def apply_roles
    return if user_invitation.role.nil?

    @invitee.add_role(user_invitation.role)
  end

  def user_invitation
    @user_invitation ||= UserInvitation.find_by_email(@invitee.email.downcase)
  end
end
