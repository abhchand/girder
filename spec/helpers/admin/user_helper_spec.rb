require 'rails_helper'

RSpec.describe Admin::UserHelper, type: :helper do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:user_invitation) { create(:user_invitation, inviter: admin) }

  let(:i18n_prefix) { 'admin.users.index' }

  before { stub_current_user(admin) }

  describe '#actions_for' do
    context 'target is a User' do
      it 'generates the button to make the target user an admin' do
        actions = to_html_node(actions_for(user))
        buttons = actions.all('button')

        expect(buttons[0]).
          to have_text(t("#{i18n_prefix}.table.actions.make_admin"))
      end

      it 'generates the button to delete the target user' do
        actions = to_html_node(actions_for(user))
        buttons = actions.all('button')

        expect(buttons[1]).
          to have_text(t("#{i18n_prefix}.table.actions.delete_user"))
      end

      context 'target user is an admin' do
        before { user.add_role(:admin) }

        it 'generates the button to remove the target user as an admin' do
          actions = to_html_node(actions_for(user))
          buttons = actions.all('button')

          expect(buttons[0]).
            to have_text(t("#{i18n_prefix}.table.actions.remove_admin"))
        end
      end

      context 'current user is not an admin' do
        before { admin.remove_role(:admin) }

        it 'generates no buttons' do
          expect(actions_for(user)).to be_nil
        end
      end

      context 'target user is the current user' do
        let(:user) { admin }

        it 'generates no buttons' do
          expect(actions_for(user)).to be_nil
        end
      end
    end

    context 'target is a UserInvitation' do
      it 'generates the button to resend the invitation' do
        actions = to_html_node(actions_for(user_invitation))
        buttons = actions.all('button')

        expect(buttons[0]).
          to have_text(t("#{i18n_prefix}.table.actions.resend_invitation"))
      end

      context 'UserInvitation is not pending' do
        before { user_invitation.update!(invitee: user) }

        it 'generates no buttons' do
          expect(actions_for(user_invitation)).to be_nil
        end
      end
    end
  end

  describe '#id_for' do
    context 'target is a User' do
      it 'returns the synthetic_id' do
        expect(id_for(user)).to eq(user.synthetic_id)
      end
    end

    context 'target is a UserInvitation' do
      it 'returns the id' do
        expect(id_for(user_invitation)).to eq(user_invitation.id)
      end
    end
  end

  describe '#name_for' do
    context 'target is a User' do
      it 'returns the user name' do
        expect(name_for(user)).to eq(user.name)
      end
    end

    context 'target is a UserInvitation' do
      it 'returns nil' do
        expect(name_for(user_invitation)).to be_nil
      end
    end
  end

  describe '#role_for' do
    context 'target is a User' do
      it 'returns an empty string' do
        expect(role_for(user)).to eq('')
      end

      context 'target user is an admin' do
        it 'returns the admin label' do
          expect(role_for(admin)).to eq(I18n.t('roles.admin.label'))
        end
      end
    end

    context 'target is a UserInvitation' do
      it 'returns nil' do
        expect(role_for(user_invitation)).to be_nil
      end
    end
  end

  describe '#status_for' do
    context 'target is a User' do
      it 'returns the active label' do
        expect(status_for(user)).to eq(t("#{i18n_prefix}.table.status.active"))
      end
    end

    context 'target is a UserInvitation' do
      it 'returns the invited label' do
        expect(status_for(user_invitation)).
          to eq(t("#{i18n_prefix}.table.status.invited"))
      end
    end
  end

  def to_html_node(str)
    Capybara::Node::Simple.new(str)
  end
end
