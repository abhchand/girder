class UserInvitationMailer < ApplicationMailer
  def invite(user_invitation_id)
    @user_invitation = UserInvitation.find(user_invitation_id)

    @recipient = @user_invitation.email
    @subject = t('.subject')
    @body = t('.body', inviter: @user_invitation.inviter.name)
    @url =
      native_auth_enabled? ? new_user_registration_url : new_user_session_url

    send_mail
  end

  def notify_inviter_of_completion(inviter_id, invitee_id)
    @inviter = User.find(inviter_id)
    @invitee = User.find(invitee_id)

    @recipient = @inviter.email
    @subject = t('.subject', invitee_name: @invitee.name)

    @body = t('.body', invitee_name: @invitee.name, settings_url: settings_url)
    @todos = t('.todos')

    send_mail
  end
end
