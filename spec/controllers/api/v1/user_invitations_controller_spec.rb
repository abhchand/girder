require 'rails_helper'

RSpec.describe Api::V1::UserInvitationsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_invitation) { create(:user_invitation) }

  describe 'GET #index' do
    let(:params) { { format: 'json' } }

    let!(:user_invitations) { create_list(:user_invitation, 3) }

    before do
      sign_in(user)
      stub_ability(user).can(:index, :user_invitations)

      stub_const('Api::Response::PaginationLinksService::PAGE_SIZE', 100)
    end

    context 'user is not signed in' do
      before { sign_out(user) }

      it 'responds with an error' do
        get :index, params: params

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['error']).to eq(
          t('devise.failure.unauthenticated')
        )
      end
    end

    context 'request is not json format' do
      before { params[:format] = 'html' }

      it 'redirects to the root_path' do
        get :index, params: params

        expect(response).to redirect_to(root_path)
      end
    end

    context 'user does not have permissions to read user invitations' do
      before { stub_ability(user).cannot(:index, :user_invitations) }

      it 'responds with an error' do
        get :index, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)['errors']).to eq(
          [{ 'title' => 'Forbidden', 'status' => '403' }]
        )
      end
    end

    describe 'data' do
      it 'responds with the data' do
        get :index, params: params

        expect(response.status).to eq(200)

        data = JSON.parse(response.body)['data']
        actual = data.map { |d| d['id'] }
        expected = user_invitations.map(&:id).map(&:to_s)

        expect(actual).to match_array(expected)
      end

      describe 'ordering' do
        it 'returns a list of all user_invitations ordered by first name' do
          user_invitations[0].update(email: 'III@X.YZ')
          user_invitations[1].update(email: 'JJJ@X.YZ')
          user_invitations[2].update(email: 'HHH@X.YZ')

          get :index, params: params

          expect(response.status).to eq(200)

          data = JSON.parse(response.body)['data']
          actual = data.map { |d| d['id'] }
          expected = [
            user_invitations[2],
            user_invitations[0],
            user_invitations[1]
          ].map(&:id).map(&:to_s)

          expect(actual).to eq(expected)
        end

        it 'orders case insensitively' do
          user_invitations[0].update(email: 'III@X.YZ')
          user_invitations[1].update(email: 'jjj@X.YZ')
          user_invitations[2].update(email: 'hHh@X.YZ')

          get :index, params: params

          expect(response.status).to eq(200)

          data = JSON.parse(response.body)['data']
          actual = data.map { |d| d['id'] }
          expected = [
            user_invitations[2],
            user_invitations[0],
            user_invitations[1]
          ].map(&:id).map(&:to_s)

          expect(actual).to eq(expected)
        end
      end

      it 'filters by the search string' do
        user_invitations[0].update(email: 'Georgia@state.gov')
        user_invitations[1].update(email: 'Virginia@state.gov')
        user_invitations[2].update(email: 'California@state.gov')

        params[:search] = 'nia'

        get :index, params: params

        expect(response.status).to eq(200)

        data = JSON.parse(response.body)['data']
        actual = data.map { |d| d['id'] }
        expected = [user_invitations[2], user_invitations[1]].map(&:id).map(
          &:to_s
        )

        expect(actual).to eq(expected)
      end
    end

    describe 'meta' do
      let(:meta) { JSON.parse(response.body)['meta'] }

      it 'includes the totalCount count in the meta information' do
        get :index, params: params

        expect(meta['totalCount']).to eq(UserInvitation.count)
      end

      context 'a search string is present' do
        it 'the totalCount is count after searching records' do
          user_invitations[0].update(email: 'Georgia')
          user_invitations[1].update(email: 'Virginia')
          user_invitations[2].update(email: 'California')

          params[:search] = 'nia'

          get :index, params: params

          expect(meta['totalCount']).to eq(2)
        end
      end
    end

    describe 'relationships' do
      let(:relationships) do
        JSON.parse(response.body)['data'][0]['relationships']
      end

      it 'responds with no relations' do
        get :index, params: params

        expect(relationships).to be_nil
      end
    end

    describe 'pagination' do
      before do
        stub_const('Api::Response::PaginationLinksService::PAGE_SIZE', 2)

        # Creates 3 pages of 2 records each
        # page 1: user_invitations[0], user_invitations[1]
        # page 2: user_invitations[2], user_invitations[3]
        # page 3: user_invitations[4]
        user_invitations[0].update(email: 'AAA@X.YZ')
        user_invitations[1].update(email: 'BBB@X.YZ')
        user_invitations[2].update(email: 'CCC@X.YZ')
        user_invitations << create(:user_invitation, email: 'EEE@X.YZ')
        user_invitations << create(:user_invitation, email: 'FFF@X.YZ')

        params[:per_page] = 2
        params[:page] = 2
      end

      it 'paginates the data based on the params' do
        get :index, params: params

        data = JSON.parse(response.body)['data']
        actual = data.map { |d| d['id'] }
        expected = [user_invitations[2], user_invitations[3]].map(&:id).map(
          &:to_s
        )

        expect(actual).to eq(expected)
      end

      it 'responds with the pagination links' do
        get :index, params: params

        links = JSON.parse(response.body)['links']

        expect(links['self']).to eq(
          api_v1_user_invitations_url(page: 2, per_page: 2)
        )
      end
    end
  end

  describe 'POST #create' do
    let(:params) do
      { format: 'json', user_invitation: { email: 'xyz@foo.com' } }
    end

    before do
      sign_in(user)
      stub_ability(user).can(:create, :user_invitation)
    end

    context 'request is not json format' do
      before { params[:format] = 'html' }

      it 'redirects to root_path' do
        post :create, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user does not have ability to create invitations' do
      before { stub_ability(user).cannot(:create, :user_invitation) }

      it 'responds as 403 forbidden' do
        post :create, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
          'Forbidden'
        )
      end
    end

    context 'error in creating the user invitation' do
      before do
        # Try creating a user invitation with a duplicate email
        params[:user_invitation][:email] = user_invitation.email
      end

      it 'does not create the user invitation and responds as failure' do
        expect { post :create, params: params }.to_not(
          change { UserInvitation.count }
        )

        msg =
          I18n.t(
            'activerecord.errors.models.user_invitation.attributes.email.' \
              'already_invited'
          )

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)).to eq('error' => msg)
      end

      it 'does not deliver any email' do
        expect { post :create, params: params }.to_not(
          change { mailer_queue.count }
        )
      end
    end

    it 'creates the user invitation and responds as success' do
      expect { post :create, params: params }.to change {
        UserInvitation.count
      }.by(1)

      user_invitation = UserInvitation.last
      expect(user_invitation.email).to eq(params[:user_invitation][:email])

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(user_invitation.as_json)
    end

    it 'emails an invitation to the invited user' do
      expect { post :create, params: params }.to change {
        enqueued_mailers.count
      }.by(1)

      email = enqueued_mailers.last
      expect(enqueued_mailers.count).to eq(1)
      expect(email[:klass]).to eq(UserInvitationMailer)
      expect(email[:mailer_name]).to eq(:invite)
      expect(email[:args][:user_invitation_id]).to eq(UserInvitation.last.id)
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { format: 'json', id: user_invitation.id } }

    before do
      sign_in(user)
      stub_ability(user).can(:destroy, UserInvitation)
    end

    context 'request is not json format' do
      before { params[:format] = 'html' }

      it 'redirects to root_path' do
        delete :destroy, params: params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user invitation is not found' do
      before { params[:id] = 'abcde' }

      it 'responds as 404 not found' do
        delete :destroy, params: params

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
          'Not Found'
        )
      end
    end

    context 'user does not have ability to edit user invitation' do
      before { stub_ability(user).cannot(:destroy, UserInvitation) }

      it 'responds as 403 forbidden' do
        delete :destroy, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
          'Forbidden'
        )
      end
    end

    it 'deletes the user invitation and responds as success' do
      user_invitation

      expect { delete :destroy, params: params }.to change {
        UserInvitation.count
      }.by(-1)

      expect(response.status).to eq(200)
      expect(response.body).to eq('{}')
    end
  end

  describe 'POST #resend' do
    let(:params) { { format: 'json' } }

    let(:user) { create(:user) }
    let(:user_invitation) { create(:user_invitation, inviter: user) }

    let(:params) { { format: 'json', user_invitation_id: user_invitation.id } }

    before do
      sign_in(user)
      stub_ability(user).can(:create, :user_invitation)
    end

    context 'user does not have permissions to create the user invitation' do
      before { stub_ability(user).cannot(:create, :user_invitation) }

      it 'responds with an error' do
        post :resend, params: params

        expect(response.status).to eq(403)
        expect(JSON.parse(response.body)['errors']).to eq(
          [{ 'title' => 'Forbidden', 'status' => '403' }]
        )
      end
    end

    describe 'User record is not found' do
      before { params[:user_invitation_id] = -1 }

      it 'responds with an error' do
        post :resend, params: params

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
          'Not Found'
        )
      end
    end

    it 'resends the invitation and responds successfully' do
      expect { post :resend, params: params }.to change {
        mailer_queue.size
      }.from(0).to(1)

      email = mailer_queue.last
      expect(email[:klass]).to eq(UserInvitationMailer)
      expect(email[:method]).to eq(:invite)
      expect(email[:args][:user_invitation_id]).to eq(user_invitation.id)

      expect(response.status).to eq(200)
      expect(response.body).to eq('')
    end
  end
end
