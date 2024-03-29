require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:leader) { create(:user) }
  let(:user) { create(:user) }

  before { sign_in(leader) }

  describe 'GET #index' do
    it 'redirects to the root_path' do
      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { format: 'json', id: user.synthetic_id } }

    before { stub_ability(leader).can(:destroy, User) }

    context 'request is not json format' do
      before { params[:format] = 'html' }

      it 'redirects to root_path' do
        delete :destroy, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user is not found' do
      before { params[:id] = 'abcde' }

      it 'responds as 404 not found' do
        delete :destroy, params: params

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
          'Not Found'
        )
      end
    end

    context 'leader does not have ability to edit user' do
      before { stub_ability(leader).cannot(:destroy, User) }

      it 'responds as 403 forbidden' do
        delete :destroy, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
          'Forbidden'
        )
      end
    end

    describe 'deactivation' do
      it 'deactivates the user and responds as success' do
        expect { delete :destroy, params: params }.to change {
          user.reload.deactivated?
        }.from(false).to(true)

        expect(response.status).to eq(200)
        expect(response.body).to eq('{}')
      end
    end

    describe 'removing roles' do
      before do
        user.add_role(:director)
        user.add_role(:manager)
      end

      it "removes all of the user's roles" do
        expect { delete :destroy, params: params }.to change {
          user.reload.roles.count
        }.from(2).to(0)

        expect(response.status).to eq(200)
        expect(response.body).to eq('{}')
      end
    end

    context 'user is already deactivated' do
      let(:now) { Time.zone.now.change(nsec: 0) }

      before { user.update!(deactivated_at: now) }

      it 'does not update the user again, but still responds as success' do
        delete :destroy, params: params

        expect(user.reload.deactivated_at).to eq(now)
        expect(response.status).to eq(200)
        expect(response.body).to eq('{}')
      end
    end
  end
end
