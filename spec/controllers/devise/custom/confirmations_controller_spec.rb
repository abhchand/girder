require 'rails_helper'

# Devise already tests this controller. This spec exists purely to test
# any additional functionality provided by the application.

RSpec.describe Devise::Custom::ConfirmationsController, type: :controller do
  let(:user) { create(:user, :native, :unconfirmed) }

  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #new' do
    before { sign_in(user) }

    it 'renders the :new template and assigns `@user' do
      get :new

      expect(response).to render_template(:new)
      expect(assigns(:user)).to eq(user)
    end

    context 'native auth is disabled' do
      before { stub_env('NATIVE_AUTH_ENABLED' => 'false') }

      it 'redirects to the root path with a flash message' do
        get :new

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t('helpers.devise.auth_helper.error'))
      end
    end

    context 'user is NOT signed in' do
      before { sign_out(user) }

      it 'redirects to the log in path with a flash message' do
        get :new

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq(t('devise.failure.unauthenticated'))
      end
    end

    context 'user is already confirmed' do
      before { user.update!(confirmed_at: Time.zone.now) }

      it 'redirects to the root path with no flash message' do
        get :new

        expect(response).to redirect_to(root_path)
        expect(flash.to_h).to eq({})
      end
    end

    context 'omniauth user' do
      let(:user) { create(:user, :omniauth, provider: 'google_oauth2') }

      it 'redirects to the root path with no flash message' do
        get :new

        expect(response).to redirect_to(root_path)
        expect(flash.to_h).to eq({})
      end
    end
  end

  describe 'GET #show' do
    context 'native auth is disabled' do
      before { stub_env('NATIVE_AUTH_ENABLED' => 'false') }

      it 'redirects to the root path with a flash message' do
        get :show

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq(t('helpers.devise.auth_helper.error'))
      end
    end
  end

  describe 'POST #create' do
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
