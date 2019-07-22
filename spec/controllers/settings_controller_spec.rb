require "rails_helper"

RSpec.describe SettingsController, type: :controller do
  let(:user) { create(:user) }

  before { session[:user_id] = user.id }

  describe "GET index" do
    it "sets the @name" do
      get :index

      expect(assigns(:name)).to eq(user.name)
    end
  end
end
