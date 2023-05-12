require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET index' do
    it 'should render the template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
