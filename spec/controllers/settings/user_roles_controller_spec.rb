require 'rails_helper'

RSpec.describe Settings::UserRolesController, type: :controller do
  let(:leader) { create(:user, :leader) }
  let(:user) { create(:user) }

  before do
    sign_in(leader)
    user.add_role(:manager)
    stub_ability(leader).can(:update_role, User)
  end

  describe 'PATCH update' do
    let(:params) { { format: 'json', id: user.synthetic_id, roles: %w[] } }

    context 'request is not json format' do
      before { params[:format] = 'html' }

      it 'redirects to root_path' do
        patch :update, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user is not found' do
      before { params[:id] = 'abcde' }

      it 'responds as 404 not found' do
        patch :update, params: params

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
          'Not Found'
        )
      end
    end

    context 'leader does not have ability to edit user' do
      before { stub_ability(leader).cannot(:update_role, User) }

      it 'responds as 403 forbidden' do
        patch :update, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)).to eq(
          'errors' => [{ 'status' => '403', 'title' => 'Forbidden' }]
        )
      end
    end

    it 'updates the user roles' do
      params[:roles] = %w[director leader]

      patch :update, params: params

      expect(response.status).to eq(200)
      expect(response.body).to eq('{}')

      expect(user.reload.roles.pluck(:name)).to match_array(%w[director leader])
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
