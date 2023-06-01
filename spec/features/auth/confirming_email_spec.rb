require 'rails_helper'

RSpec.feature 'Confirming Email', type: :feature do
  let(:user_attrs) do
    {
      first_name: 'Asha',
      last_name: 'Bhosle',
      email: 'asha@singers.com',
      password: 'Best!s0ngz'
    }
  end

  let(:user) { User.last }

  before { register(user_attrs) }

  it 'user can confirm their email from the link' do
    confirm(user)

    user.reload

    expect(page).to have_current_path(user.signed_in_path)
    expect(page).to_not have_selector('.flash')

    expect(user.reload.confirmed?).to eq(true)
  end

  context 'invalid token' do
    it 'user sees an auth error when clicking the link' do
      confirm(user, token: 'abcde')

      expect(page).to have_current_path(
        user_confirmation_path(confirmation_token: 'abcde')
      )
      expect(page).to have_auth_error(
        validation_error_for(:confirmation_token, :invalid)
      )

      expect(user.reload.confirmed?).to eq(false)
    end
  end

  context 'expired token' do
    before { @grace_period = Devise.confirm_within }

    it 'user sees an auth error when clicking the link' do
      raise 'expected non-nil value!' unless @grace_period

      travel(@grace_period + 1.day) { confirm(user) }

      expect(page).to have_current_path(
        user_confirmation_path(confirmation_token: user.confirmation_token)
      )
      expect(page).to have_auth_error(
        t('errors.messages.confirmation_period_expired', period: '3 days')
      )

      expect(user.reload.confirmed?).to eq(false)
    end
  end

  context 'email is already confirmed' do
    it 'user sees a error message when clicking the link' do
      user.update!(confirmed_at: Time.zone.now)
      confirm(user)

      expect(page).to have_current_path(
        user_confirmation_path(confirmation_token: user.confirmation_token)
      )
      expect(page).to have_auth_error(t('errors.messages.already_confirmed'))

      expect(user.reload.confirmed?).to eq(true)
    end
  end

  context 'email is pending reconfirmation' do
    before { user.update!(unconfirmed_email: 'unconfirmed@xyz.com') }

    it 'user can confirm their new email from the link' do
      expect { confirm(user) }.to(
        change { user.reload.pending_reconfirmation? }.from(true).to(false)
      )
      expect(user.reload.confirmed?).to eq(true)

      expect(page).to have_current_path(user.signed_in_path)
      expect(page).to_not have_selector('.flash')
    end
  end

  context 'omniauth account' do
    let(:user) { create(:user, :omniauth, provider: 'google_oauth2') }

    # We skip the email confirmation process for omniauth logins since we
    # assume the third party service has already verified this.

    it 'user sees error that confirmation token is blank when clicking link' do
      expect(user.confirmation_token).to be_nil

      confirm(user)

      expect(page).to have_current_path(
        user_confirmation_path(confirmation_token: user.confirmation_token)
      )
      expect(page).to have_auth_error(
        validation_error_for(:confirmation_token, :blank)
      )

      # We still consider the account confirmed because it's omniauth, even
      # though `confirmed_at` is `nil`
      expect(user.reload.confirmed?).to eq(true)
    end

    context 'confirmation token exists' do
      # The User model validates that no confirmation attributes are set
      # for omniauth records, so this test scenario wouldn't realistically ever
      # occur.
      #
      # However, we still want to test it because -
      #   1. We want to document the behavior in specs
      #   2. If the validations are ever bypassed for any reason, we want to
      #      confirm behavior
      #

      before do
        user.update_column(:confirmed_at, nil)
        user.update_column(:confirmation_sent_at, 1.minute.ago)
        user.update_column(:confirmation_token, Devise.friendly_token)
      end

      it 'shows error that account is already confirmed when clicking link' do
        confirm(user)

        expect(page).to have_current_path(
          user_confirmation_path(confirmation_token: user.confirmation_token)
        )
        expect(page).to have_auth_error(t('errors.messages.already_confirmed'))

        # We still consider the account confirmed because it's omniauth, even
        # though `confirmed_at` is `nil`
        expect(user.reload.confirmed?).to eq(true)
      end
    end
  end

  describe 'resending confirmation email' do
    it 'user can resend the confirmation email' do
      old_token = user.confirmation_token

      expect do
        expect { resend_confirmation }.to_not(change { user.reload.confirmed? })
      end.to change { enqueued_mailers.count }.by(1)

      expect(page).to have_current_path(user.signed_in_path)
      expect(page).to_not have_selector('.flash')

      new_token = user.reload.confirmation_token
      expect(old_token).to eq(new_token)

      email = enqueued_mailers.last
      expect(email[:klass]).to eq(Devise::Mailer)
      expect(email[:mailer_name]).to eq(:confirmation_instructions)
      expect(email[:args][:record]).to eq(user)
      expect(email[:args][:token]).to eq(new_token)
      expect(email[:args][:opts]).to eq({})
    end
  end
end
