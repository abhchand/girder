class UserInvitation::MarkAsCompleteJob < ApplicationWorker
  def perform(invitee_id)
    @invitee = User.find(invitee_id)
    @invitation = UserInvitation.find_by_email(@invitee.email.downcase)

    return if @invitation.blank?

    notify
    destroy
  end

  private

  def destroy
    @invitation.destroy!
  end

  def notify
    UserInvitationMailer.notify_inviter_of_completion(
      @invitation.inviter.id,
      @invitee.id
    ).deliver_later
  end
end
