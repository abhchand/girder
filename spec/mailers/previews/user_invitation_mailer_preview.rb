class UserInvitationMailerPreview < ActionMailer::Preview
  def invite
    user_invitation = UserInvitation.last
    raise 'No UserInvitation found' if user_invitation.blank?

    UserInvitationMailer.invite(user_invitation.id)
  end

  def notify_inviter_of_completion
    inviter = User.all.sample
    invitee = User.all.sample
    raise 'No Users found' if inviter.blank? || invitee.blank?

    UserInvitationMailer.notify_inviter_of_completion(inviter.id, invitee.id)
  end
end
