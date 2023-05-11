require 'rails_helper'

RSpec.describe UserInvitation::MarkAsCompleteJob do
  let(:user) { create(:user) }
  let(:invitation) { create(:user_invitation, email: user.email) }

  it 'sends the UserInvitationMailer#notify_inviter_of_completion mailer' do
    invitation

    expect { call }.to(change { mailer_queue.count }.by(1))

    email = mailer_queue.last
    expect(email[:klass]).to eq(UserInvitationMailer)
    expect(email[:method]).to eq(:notify_inviter_of_completion)
    expect(email[:args][:inviter_id]).to eq(invitation.inviter.id)
    expect(email[:args][:invitee_id]).to eq(user.id)
  end

  it 'destroys the UserInvitation record' do
    invitation

    expect { call }.to change { UserInvitation.count }.by(-1)
    expect { invitation.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  context 'no invitation exists' do
    it 'does not send the mailer' do
      expect { call }.to_not(change { mailer_queue.count })
    end

    it 'does not destroy the UserInvitation record' do
      expect { call }.to_not change { UserInvitation.count }
    end
  end

  def call
    UserInvitation::MarkAsCompleteJob.new.perform(user.id)
  end
end
