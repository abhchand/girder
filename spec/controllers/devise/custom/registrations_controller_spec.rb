require 'rails_helper'

# Devise already tests this controller. This spec exists purely to test
# any additional functionality provided by the application.

RSpec.describe Devise::Custom::RegistrationsController, type: :controller do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #cancel' do
    context 'native auth is disabled' do
      before { stub_env('NATIVE_AUTH_ENABLED' => 'false') }

      it 'redirects to the root path with a flash message' do
        get :cancel

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t('helpers.devise.auth_helper.error'))
      end
    end
  end

  describe 'GET #new' do
    context 'native auth is disabled' do
      before { stub_env('NATIVE_AUTH_ENABLED' => 'false') }

      it 'redirects to the root path with a flash message' do
        get :new

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t('helpers.devise.auth_helper.error'))
      end
    end
  end

  describe 'GET #edit' do
    context 'user is signed in' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it 'redirects to the account_index_path' do
        get :edit

        expect(response).to redirect_to(account_index_path)
      end
    end

    context 'native auth is disabled' do
      before { stub_env('NATIVE_AUTH_ENABLED' => 'false') }

      it 'redirects to the root path with a flash message' do
        get :edit

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t('helpers.devise.auth_helper.error'))
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user, password: params[:user][:current_password]) }

    let(:params) do
      {
        user: {
          current_password: 'b3sts0ngz#',
          password: 'testPword#01',
          password_confirmation: 'testPword#01'
        },
        format: 'json'
      }
    end

    before { sign_in(user) }

    context 'native auth is disabled' do
      before { stub_env('NATIVE_AUTH_ENABLED' => 'false') }

      it 'redirects to the root path with a flash message' do
        patch :update

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t('helpers.devise.auth_helper.error'))
      end
    end

    context 'updating passwords' do
      context 'format is not json' do
        before { params.delete(:format) }

        it 'updates the password and redirects' do
          expect(user.valid_password?(params[:user][:current_password])).to eq(
            true
          )

          patch :update, params: params

          user.reload
          expect(user.valid_password?(params[:user][:current_password])).to eq(
            false
          )
          expect(user.valid_password?(params[:user][:password])).to eq(true)

          expect(response).to redirect_to(root_path)
        end
      end

      context 'format is json' do
        it 'updates the password and responds in JSON' do
          expect(user.valid_password?(params[:user][:current_password])).to eq(
            true
          )

          patch :update, params: params

          user.reload
          expect(user.valid_password?(params[:user][:current_password])).to eq(
            false
          )
          expect(user.valid_password?(params[:user][:password])).to eq(true)

          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to eq({})
        end

        context 'error while updating password' do
          before { params[:user][:password_confirmation] = 'foo' }

          it 'serializes and responds with the errors' do
            patch :update, params: params

            expect(response.status).to eq(400)
            expect(JSON.parse(response.body)['errors']).to eq(
              [
                {
                  'title' => 'Invalid Password',
                  'description' =>
                    'Password confirmation does not match password',
                  'status' => '403'
                }
              ]
            )
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'native auth is disabled' do
      before { stub_env('NATIVE_AUTH_ENABLED' => 'false') }

      it 'redirects to the root path with a flash message' do
        delete :destroy

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t('helpers.devise.auth_helper.error'))
      end
    end
  end

  describe 'POST #create' do
    let(:params) do
      {
        user: {
          first_name: 'Nasir',
          last_name: 'Jones',
          email: 'nas@queensbridge.nyc',
          password: 'b3sts0ngz#',
          password_confirmation: 'b3sts0ngz#'
        }
      }
    end

    before { request.env['devise.mapping'] = Devise.mappings[:user] }

    it 'sends a confirmation email' do
      # This happens inside Devise, in an `after_commit` callback
      expect do post :create, params: params end.to change {
        enqueued_mailers.count
      }.by(1)

      user = User.last

      email = enqueued_mailers.last
      expect(email[:klass]).to eq(Devise::Mailer)
      expect(email[:mailer_name]).to eq(:confirmation_instructions)
      expect(email[:args][:record]).to eq(user)
      expect(email[:args][:token]).to eq(user.confirmation_token)
      expect(email[:args][:opts]).to eq({})
    end

    it 'calls the `UserInvitations::RegistrationService` service' do
      expect(UserInvitations::RegistrationService).to receive(:call)

      post :create, params: params
    end

    it 'enqueues the `UserInvitation::MarkAsCompleteJob` job' do
      expect do
        expect do post :create, params: params end.to change {
          UserInvitation::MarkAsCompleteJob.jobs.count
        }.by(1)
      end.to change { User.count }.by(1)

      job = UserInvitation::MarkAsCompleteJob.jobs.last
      user = User.last

      expect(job['args']).to eq([user.id])
    end

    context 'user record failed to create' do
      # Should cause failure when calling `resource.save` in
      # `registrations#create` in Devise
      before { expect_any_instance_of(User).to receive(:save) { false } }

      it 'does not call the `UserInvitations::RegistrationService` service' do
        expect(UserInvitations::RegistrationService).to_not receive(:call)

        post :create, params: params
      end

      it 'does not enqueue the `UserInvitation::MarkAsCompleteJob` job' do
        expect do post :create, params: params end.to_not change {
          UserInvitation::MarkAsCompleteJob.jobs.count
        }
      end
    end

    context 'native auth is disabled' do
      before { stub_env('NATIVE_AUTH_ENABLED' => 'false') }

      it 'redirects to the root path with a flash message' do
        post :create

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t('helpers.devise.auth_helper.error'))
      end
    end
  end
end
