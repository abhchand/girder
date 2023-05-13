require 'rails_helper'

RSpec.feature 'Settings - Managing Users', type: :feature, js: true do
  let(:leader) { create(:user, :leader) }

  before { log_in(leader) }

  context 'User records' do
    let!(:user) { create(:user) }

    it 'toggle another user\'s Leader status' do
      visit settings_users_path

      # Click first button: Add Leader
      leader_actions_for(user)[0].click
      sleep(5)

      expect(page).to have_current_path(settings_users_path)
      expect(user.reload.has_role?(:leader)).to eq(true)

      # Click first button: Remove Leader
      leader_actions_for(user)[0].click
      sleep(5)

      expect(page).to have_current_path(settings_users_path)
      expect(user.reload.has_role?(:leader)).to eq(false)
    end

    it 'leader can delete another user' do
      visit settings_users_path

      # Click second button: Delete User
      leader_actions_for(user)[1].click
      sleep(5)

      expect(page).to have_current_path(settings_users_path)
      expect(User.find_by_id(user.id)).to be_nil
    end

    it 'shows a flash message if anything goes wrong' do
      visit settings_users_path

      # Secretly delete the User
      user.destroy!

      # Click first button: Add Leader
      leader_actions_for(user)[0].click
      sleep(5)

      expect(page).to have_current_path(settings_users_path)
      expect(page).to have_flash_message(t('generic_error')).of_type(:error)
    end
  end

  context 'UserInvitation Records' do
    let!(:user_invitation) { create(:user_invitation, inviter: leader) }

    it 'leader can resend invitations' do
      visit settings_users_path

      # Click first button: Resend Invitation
      leader_actions_for(user_invitation)[0].click
      sleep(7)

      expect(page).to have_current_path(settings_users_path)

      email = mailer_queue.last
      expect(mailer_queue.size).to eq(1)
      expect(email[:klass]).to eq(UserInvitationMailer)
      expect(email[:method]).to eq(:invite)
      expect(email[:args][:user_invitation_id]).to eq(user_invitation.id)
    end
  end

  def leader_actions_for(target)
    id = target.try(:synthetic_id) || target.id

    row = page.find(".settings-users-index-table__row[data-id='#{id}']")
    row.find('.actions').all('button')
  end
end
