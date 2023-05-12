require 'rails_helper'

RSpec.describe Settings::UsersController, type: :controller do
  let(:user) { create(:user, first_name: 'Alonso', last_name: 'Harris') }

  before { sign_in(user) }

  describe 'GET index' do
    context 'assigning @users' do
      it 'assigns @users as the ordered list of Users' do
        # Sorting is by first_name, last_name, email
        # Create Users so that the order will be [user, u3, u2]
        u2 =
          create(
            :user,
            first_name: user.first_name,
            last_name: 'Zzz',
            email: 'z@b.c'
          )
        u3 =
          create(
            :user,
            first_name: user.first_name,
            last_name: 'Zzz',
            email: 'a@b.c'
          )

        get :index

        expect(assigns(:users)).to eq([user, u3, u2])
      end

      it 'prepends an ordered list of UserInvitation records, if any exist' do
        # Sorting is by UserInvitations first (email), and then by
        # Users
        # Create UserInvitations and Users so that the order will be
        # [ui3, ui2, user]
        u2 = create(:user_invitation, inviter: user, email: 'z@b.c')
        u3 = create(:user_invitation, inviter: user, email: 'a@b.c')

        get :index

        expect(assigns(:users)).to eq([u3, u2, user])
      end
    end

    it 'should render the template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
