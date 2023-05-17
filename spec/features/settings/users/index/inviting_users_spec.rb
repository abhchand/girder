require 'rails_helper'

RSpec.feature 'Settings - Inviting Users', type: :feature, js: true do
  let(:leader) { create(:user, :leader) }
  let(:user_invitation) { create(:user_invitation, inviter: leader) }

  before { log_in(leader) }

  it 'user with permissions can invite users' do
    visit settings_users_path

    fill_in('user_invitation[email]', with: 'foo@example.com')

    expect do
      user_invitation_submit_btn.click
      wait_for_async_process('user-invitation-form-submit', delay: 1)
    end.to change { UserInvitation.count }.by(1)

    # Invitation is created
    user_invitation = UserInvitation.last
    expect(user_invitation.email).to eq('foo@example.com')
    expect(user_invitation.inviter).to eq(leader)

    # Email is sent
    email = mailer_queue.last
    expect(mailer_queue.count).to eq(1)
    expect(email[:klass]).to eq(UserInvitationMailer)
    expect(email[:method]).to eq(:invite)
    expect(email[:args][:user_invitation_id]).to eq(user_invitation.id)

    # Page is updated
    expect(page).to have_current_path(settings_users_path)
    expect(page).to have_selector(
      ".settings-users-index-table__row[data-id='#{user_invitation.id}']"
    )
  end

  it 'user with permissions can resend invitations' do
    user_invitation

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

  def user_invitation_submit_btn
    page.find(
      ".settings-users-index__user-invitation-form input[type='submit']"
    )
  end

  def leader_actions_for(target)
    id = target.try(:synthetic_id) || target.id

    row = page.find(".settings-users-index-table__row[data-id='#{id}']")
    row.find('.actions').all('button')
  end
end
