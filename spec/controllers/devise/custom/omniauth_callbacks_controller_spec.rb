require 'rails_helper'

# Devise already tests this controller. This spec exists purely to test
# any additional functionality provided by the application.

RSpec.describe Devise::Custom::OmniauthCallbacksController, type: :controller do
  describe 'GET #google_oauth2' do
    let(:auth) do
      OmniAuth::AuthHash.new(
        uid: 'some-fake-uid',
        info: {
          first_name: 'Srinivasa',
          last_name: 'Ramanujan',
          email: 'srini@math.com',
          image: fixture_path_for('images/chennai.jpg')
        }
      )
    end

    before do
      request.env['omniauth.auth'] = auth
      request.env['devise.mapping'] = Devise.mappings[:user]
    end

    it 'creates, signs in, and redirects the user' do
      expect { get :google_oauth2 }.to(change { User.count }.by(1))

      user = User.last

      expect(controller.current_user).to eq(user)
      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to be_nil
    end

    context 'google_oauth2 is disabled' do
      before { stub_env('GOOGLE_OMNIAUTH_ENABLED' => 0) }

      it 'redirects to the login page' do
        get :google_oauth2

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'error in creating' do
      before { auth[:info][:email] = 'bad-email' }

      it 'sets a flash message and redirects to the login page' do
        expect { get :google_oauth2 }.to_not(change { User.count })

        expect(controller.current_user).to be_nil
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:error]).to eq(t('generic_error'))
      end
    end

    context 'a UserInvitation record exists with this email' do
      let!(:invitation) { create(:user_invitation, email: auth[:info][:email]) }

      it 'enqueues the `UserInvitation::MarkAsCompleteJob` job' do
        expect do
          expect do get :google_oauth2 end.to change {
            UserInvitation::MarkAsCompleteJob.jobs.count
          }.by(1)
        end.to change { User.count }.by(1)

        job = UserInvitation::MarkAsCompleteJob.jobs.last
        user = User.last

        expect(job['args']).to eq([user.id])
      end

      context 'user record failed to create' do
        before { auth[:uid] = nil }

        it 'does not enqueue the `UserInvitation::MarkAsCompleteJob` job' do
          expect do get :google_oauth2 end.to_not change {
            UserInvitation::MarkAsCompleteJob.jobs.count
          }
        end
      end
    end

    context 'User already exists' do
      let!(:user) do
        create(
          :user,
          :omniauth,
          uid: auth[:uid],
          first_name: auth[:info][:first_name],
          last_name: auth[:info][:last_name],
          email: auth[:info][:email]
        )
      end

      it 'signs in and redirects the user' do
        expect { get :google_oauth2 }.to_not(change { User.count })

        user = User.last

        expect(controller.current_user).to eq(user)
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to be_nil
      end

      context 'a UserInvitation record exists for this user\'s email' do
        let(:invitation) do
          create(:user_invitation, email: auth[:info][:email])
        end

        it 'does not update the invitation' do
          expect { get :google_oauth2 }.to_not(
            change { invitation.reload.updated_at }
          )
        end

        it 'does not deliver any mailer notifications' do
          expect { get :google_oauth2 }.to_not(change { mailer_queue.count })
        end
      end
    end
  end
end
