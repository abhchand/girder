require 'rails_helper'

RSpec.describe UserInvitations::MarkAsComplete do
  let(:user) { create(:user) }
  let(:invitation) { create(:user_invitation, email: user.email) }

  it 'updates the invitee on the UserInvitation record' do
    invitation

    expect { call }.to change { invitation.reload.invitee }.from(nil).to(user)
  end

  it 'calls UserInvitations::NotifyInviterOfCompletion' do
    invitation

    expect(UserInvitations::NotifyInviterOfCompletion).to receive(:call)
    call
  end

  context 'no invitation exists' do
    it 'does nothing' do
      user

      expect { call }.to_not raise_error
    end

    it 'does not call UserInvitations::NotifyInviterOfCompletion' do
      expect(UserInvitations::NotifyInviterOfCompletion).to_not receive(:call)
      call
    end
  end

  def call
    UserInvitations::MarkAsComplete.call(user)
  end
end
