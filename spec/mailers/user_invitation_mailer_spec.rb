require 'rails_helper'

RSpec.describe UserInvitationMailer do
  let(:hostname) { ApplicationMailer.send(:new).send(:hostname) }

  describe 'invite' do
    let(:mail) { UserInvitationMailer.invite(@user_invitation.id) }

    before do
      @user_invitation = create(:user_invitation)
      @t_prefix = 'user_invitation_mailer.invite'
    end

    it 'sends the email to the user' do
      expect(mail.from).to eq([ENV['EMAIL_FROM']])
      expect(mail.to).to eq([@user_invitation.email])
      expect(mail.subject).to eq(t("#{@t_prefix}.subject"))
    end

    it "displays the inviter's name" do
      expect(mail.body).to have_content(@user_invitation.inviter.name)
    end

    it 'displays the new registration url' do
      url = new_user_registration_url
      expect(mail.body).to have_link(url, href: url)
    end

    context 'native auth is disabled' do
      before { stub_env('NATIVE_AUTH_ENABLED' => 'false') }

      it 'displays the new session url' do
        url = new_user_session_url
        expect(mail.body).to have_link(url, href: url)
      end
    end
  end

  describe 'notify_inviter_of_completion' do
    let(:mail) do
      UserInvitationMailer.notify_inviter_of_completion(inviter.id, invitee.id)
    end

    let(:inviter) { create(:user) }
    let(:invitee) { create(:user) }

    before do
      @user_invitation = create(:user_invitation, inviter: inviter)
      @t_prefix = 'user_invitation_mailer.notify_inviter_of_completion'
    end

    it 'sends the email to the user' do
      expect(mail.from).to eq([ENV['EMAIL_FROM']])
      expect(mail.to).to eq([inviter.email])
      expect(mail.subject).to eq(
        t("#{@t_prefix}.subject", invitee_name: invitee.name)
      )
    end

    it "displays the invitee's name" do
      expect(mail.body).to have_content(invitee.name)
    end

    it 'displays the settings url' do
      url = expect(mail.body).to have_link('settings page', href: settings_url)
    end
  end
end
