require 'rails_helper'

RSpec.feature 'Signing Up', type: :feature do
  let(:user_attrs) do
    {
      first_name: 'Asha',
      last_name: 'Bhosle',
      email: 'asha@singers.com',
      password: 'b3sts0ngz#'
    }
  end

  let(:signed_in_path) { photos_path }

  it 'user can sign up and receive a confirmation email' do
    expect { register(user_attrs) }.to(change { User.count }.by(1))

    expect(page).to have_current_path(new_user_confirmation_path)
    expect(page).to_not have_selector('.flash')

    user = User.last
    expect(user.confirmed?).to eq(false)
    expect(user.first_name).to eq(user_attrs[:first_name])
    expect(user.last_name).to eq(user_attrs[:last_name])
    expect(user.email).to eq(user_attrs[:email])
    expect(user.valid_password?(user_attrs[:password])).to eq(true)
    expect(user.confirmation_token).to_not be_nil

    email = enqueued_mailers.first
    expect(enqueued_mailers.count).to eq(1)
    expect(email[:klass]).to eq(Devise::Mailer)
    expect(email[:mailer_name]).to eq(:confirmation_instructions)
    expect(email[:args][:record]).to eq(user)
  end

  # Repeat the same test above with JS enabled so we can test the slider card
  # on the sign up screen
  it 'user can sign up (JS)', js: true do
    expect { register(user_attrs) }.to(change { User.count }.by(1))

    expect(page).to have_current_path(new_user_confirmation_path)
    expect(page).to_not have_selector('.flash')

    user = User.last
    expect(user.email).to eq(user_attrs[:email])
  end

  describe 'form validation' do
    describe 'client-side' do
      it 'displays the password criteria in real time', js: true do
        visit new_user_registration_path
        # Click the "Sign Up With Email" button first
        page.find('.registrations-new__email-registration-btn').click

        input = page.find("[name='user[password]']")

        # Dialog doesn't appear until focused
        expect(page).to_not have_selector('.password-criteria')

        # Initial
        input.send_keys('t')
        expect_password_criteria_dialog_to_be(
          length: false,
          letter: true,
          number: false,
          special: false
        )

        input.send_keys('estAccount#01')
        expect_password_criteria_dialog_to_be(
          length: true,
          letter: true,
          number: true,
          special: true
        )

        # Focus on some other element - dialog should disappear
        page.find("[name='user[first_name]']").send_keys('foo')
        expect(page).to_not have_selector('.password-criteria')
      end
    end

    describe 'server-side' do
      it 'displays an auth error when a field is blank' do
        user_attrs[:email] = ''

        expect { register(user_attrs) }.to_not(change { User.count })

        expect_auth_error_for(:email, :blank)
        expect(mailer_queue.count).to eq(0)
      end

      it "displays an auth error when passwords don't match" do
        user_attrs[:password_confirmation] = 'foo'

        expect { register(user_attrs) }.to_not(change { User.count })

        expect_auth_error_for(:password_confirmation, :confirmation)
        expect(mailer_queue.count).to eq(0)
      end

      it 'validates the password complexity' do
        user_attrs[:password] = 'sup'

        expect { register(user_attrs) }.to_not(change { User.count })

        expect_auth_error_for(:password, :invalid)
        expect(mailer_queue.count).to eq(0)
      end
    end
  end

  context 'registration email domain whitelisting is enabled' do
    before do
      stub_env('REGISTRATION_EMAIL_DOMAIN_WHITELIST' => 'example.com,x.yz')
    end

    it 'allows registration when the domain is in the whitelist' do
      user_attrs[:email] = 'foo@x.yz'

      expect { register(user_attrs) }.to(change { User.count }.by(1))

      expect(page).to have_current_path(new_user_confirmation_path)

      user = User.last
      expect(user.email).to eq(user_attrs[:email])
    end

    it 'disallows registration when the domain is not in the whitelist' do
      user_attrs[:email] = 'fake@bad-domain.gov'

      expect { register(user_attrs) }.to_not(change { User.count })

      expect_auth_error_for(:email, :invalid_domain, domain: 'bad-domain.gov')
    end
  end

  context 'an account with that email already exists' do
    let(:user) { create(:user) }

    before { user_attrs[:email] = user.email }

    shared_examples 'displays an auth error' do
      it 'displays an auth error' do
        user_attrs[:email] = user.email

        before_updated_at = user.updated_at.change(nsec: 0)
        clear_mailer_queue

        expect { register(user_attrs) }.to_not(change { User.count })

        expect_auth_error_for(:email, :taken)

        after_updated_at = user.reload.updated_at.change(nsec: 0)
        expect(after_updated_at).to eq(before_updated_at)

        expect(mailer_queue.count).to eq(0)
      end
    end

    it_behaves_like 'displays an auth error'

    it 'is case and space insensitive' do
      user_attrs[:email] = " #{user.email.upcase} "
      expect { register(user_attrs) }.to_not(change { User.count })

      expect_auth_error_for(:email, :taken)
      expect(mailer_queue.count).to eq(0)
    end

    context 'account is unconfirmed' do
      let(:user) { create(:user, :unconfirmed) }

      it_behaves_like 'displays an auth error'
    end

    context 'account has pending email change' do
      let(:user) { create(:user, :pending_reconfirmation) }

      it_behaves_like 'displays an auth error'
    end
  end

  context 'a user invitation exists' do
    let!(:invitation) { create(:user_invitation, email: user_attrs[:email]) }

    it 'enqueues the `UserInvitation::MarkAsCompleteJob` job' do
      expect do
        expect do register(user_attrs) end.to change {
          UserInvitation::MarkAsCompleteJob.jobs.count
        }.by(1)
      end.to change { User.count }.by(1)

      job = UserInvitation::MarkAsCompleteJob.jobs.last
      user = User.last

      expect(job['args']).to eq([user.id])
    end
  end

  # "Signing up" with OmniAuth is a bit different because a successful sign
  # up / user creation automatically logs you in immediately after. Therefore
  # the specs below also test some aspects of logging in initially
  describe 'omniauth account' do
    let(:auth_hash) do
      {
        uid: 'some-fake-uid',
        info: {
          first_name: 'Srinivasa',
          last_name: 'Ramanujan',
          email: 'srini@math.com',
          image: fixture_path_for('images/chennai.jpg')
        }
      }
    end

    it 'user can log in and create an account' do
      mock_google_oauth2_auth_response(auth_hash)

      expect { log_in_with_omniauth('google_oauth2') }.to(
        change { User.count }.by(1)
      )

      expect(page).to have_current_path(signed_in_path)

      user = User.last
      expect(user.first_name).to eq(auth_hash[:info][:first_name])
      expect(user.last_name).to eq(auth_hash[:info][:last_name])
      expect(user.email).to eq(auth_hash[:info][:email])
      expect(user.uid).to eq(auth_hash[:uid])
      expect(user.provider).to eq('google_oauth2')
      expect(user.avatar.attached?).to eq(true)
    end

    it "preserves the user's original destination" do
      visit account_index_path

      expect(page).to have_current_path(new_user_session_path)

      # Failed Login Attempt
      mock_google_oauth2_auth_error(:invalid_credentials)

      expect { log_in_with_omniauth('google_oauth2') }.to_not(
        change { User.count }
      )
      expect(page).to have_current_path(new_user_session_path)

      # Successful Login Attempt

      mock_google_oauth2_auth_response(auth_hash)
      expect { log_in_with_omniauth('google_oauth2') }.to(
        change { User.count }.by(1)
      )
      expect(page).to have_current_path(account_index_path)
    end

    context 'a user invitation exists' do
      let!(:invitation) do
        create(:user_invitation, email: auth_hash[:info][:email])
      end

      it 'enqueues the `UserInvitation::MarkAsCompleteJob` job' do
        expect do
          expect do
            mock_google_oauth2_auth_response(auth_hash)
            log_in_with_omniauth('google_oauth2')
          end.to change { UserInvitation::MarkAsCompleteJob.jobs.count }.by(1)
        end.to change { User.count }.by(1)

        job = UserInvitation::MarkAsCompleteJob.jobs.last
        user = User.last

        expect(job['args']).to eq([user.id])
      end
    end

    context 'omniauth results in a failure' do
      before { mock_google_oauth2_auth_error(:invalid_credentials) }

      it 'redirects to the failure path' do
        expect { log_in_with_omniauth('google_oauth2') }.to_not(
          change { User.count }
        )

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_flash_message(
          t('devise.omniauth_callbacks.failure', reason: 'Invalid credentials')
        )
      end
    end

    context 'registration email domain whitelisting is enabled' do
      before do
        stub_env('REGISTRATION_EMAIL_DOMAIN_WHITELIST' => 'example.com,x.yz')
      end

      it 'allows registration when the domain is in the whitelist' do
        auth_hash[:info][:email] = 'foo@x.yz'
        mock_google_oauth2_auth_response(auth_hash)

        expect { log_in_with_omniauth('google_oauth2') }.to(
          change { User.count }.by(1)
        )

        expect(page).to have_current_path(signed_in_path)

        user = User.last
        expect(user.email).to eq(auth_hash[:info][:email])
      end

      it 'disallows registration when the domain is not in the whitelist' do
        auth_hash[:info][:email] = 'fake@bad-domain.gov'
        mock_google_oauth2_auth_response(auth_hash)

        expect { log_in_with_omniauth('google_oauth2') }.to_not(
          change { User.count }
        )

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_flash_message(
          validation_error_for(
            :email,
            :invalid_domain,
            domain: 'bad-domain.gov'
          )
        )
      end
    end

    context 'native auth is disabled' do
      before { stub_env('NATIVE_AUTH_ENABLED' => 'false') }

      it 'user can still log in and create an account' do
        mock_google_oauth2_auth_response(auth_hash)

        expect { log_in_with_omniauth('google_oauth2') }.to(
          change { User.count }.by(1)
        )

        expect(page).to have_current_path(signed_in_path)
      end
    end

    describe 'tracking log ins' do
      let(:now) { Time.zone.now }

      it 'updates tracking infomation' do
        mock_google_oauth2_auth_response(auth_hash)

        travel_to(now) do
          expect { log_in_with_omniauth('google_oauth2') }.to(
            change { User.count }.by(1)
          )
        end

        user = User.last
        expect(user.reload.sign_in_count).to eq(1)

        # 1. Timestamps seem to be stored as rounded to the nearest whole second
        # 2. "Last sign in" is updated to match "current sign in" info if blank

        expect(user.current_sign_in_at).to eq(now.change(usec: 0))
        expect(user.current_sign_in_ip.to_s).to eq('127.0.0.1')

        expect(user.last_sign_in_at).to eq(now.change(usec: 0))
        expect(user.last_sign_in_ip).to eq('127.0.0.1')
      end
    end
  end

  def expect_auth_error_for(attribute, key, opts = {})
    expect(page).to have_current_path(user_registration_path)
    expect(page).to have_auth_error(validation_error_for(attribute, key, opts))
  end
end
