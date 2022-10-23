require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin) do
    create(:user, :admin, first_name: 'Alonso', last_name: 'Harris')
  end

  before { sign_in(admin) }

  describe 'GET index' do
    it 'calls the `admin_only` filter' do
      expect(controller).to receive(:admin_only).and_call_original
      get :index
    end

    context 'assigning @users' do
      it 'assigns @users as the ordered list of Users' do
        # Sorting is by first_name, last_name, email
        # Create Users so that the order will be [admin, u3, u2]
        u2 = create(
          :user,
          first_name: admin.first_name,
          last_name: 'Zzz',
          email: 'z@b.c'
        )
        u3 = create(
          :user,
          first_name: admin.first_name,
          last_name: 'Zzz',
          email: 'a@b.c'
        )

        get :index

        expect(assigns(:users)).to eq([admin, u3, u2])
      end

      it 'prepends an ordered list of UserInvitation records, if any exist' do
        # Sorting is by UserInvitations first (email), and then by
        # Users
        # Create UserInvitations and Users so that the order will be
        # [ui3, ui2, admin]
        u2 = create(:user_invitation, inviter: admin, email: 'z@b.c')
        u3 = create(:user_invitation, inviter: admin, email: 'a@b.c')

        get :index

        expect(assigns(:users)).to eq([u3, u2, admin])
      end
    end

    it 'should render the template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
