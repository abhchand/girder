require 'rails_helper'

RSpec.describe UserInvitations::RegistrationService, type: :interactor do
  let!(:invitee) { create(:user) }
  let(:user_invitation) { create(:user_invitation, email: invitee.email) }

  describe '.call' do
    it 'adds the role to the user' do
      user_invitation.update!(role: :manager)

      expect do
        UserInvitations::RegistrationService.call(invitee)
      end.to change { invitee.has_role?(:manager) }.from(false).to(true)
    end

    context 'no user invitation exists' do
      it 'does nothing' do
        expect do
          UserInvitations::RegistrationService.call(invitee)
        end.to_not change { invitee.roles }
      end
    end

    context 'no role exists' do
      before { user_invitation.update!(role: nil) }

      it 'does nothing' do
        expect do
          UserInvitations::RegistrationService.call(invitee)
        end.to_not change { invitee.roles }
      end
    end
  end
end
