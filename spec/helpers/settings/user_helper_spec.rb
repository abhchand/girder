require 'rails_helper'

RSpec.describe Settings::UserHelper, type: :helper do
  let(:leader) { create(:user, :leader) }
  let(:user) { create(:user) }
  let(:user_invitation) { create(:user_invitation, inviter: leader) }

  let(:i18n_prefix) { 'settings.users.index' }

  before { stub_current_user(leader) }

  describe '#actions_for' do
    context 'target is a User' do
      it 'generates the button to make the target user an leader' do
        actions = to_html_node(actions_for(user))
        buttons = actions.all('button')

        expect(buttons[0]).to have_text(
          t("#{i18n_prefix}.table.actions.make_leader")
        )
      end

      it 'generates the button to delete the target user' do
        actions = to_html_node(actions_for(user))
        buttons = actions.all('button')

        expect(buttons[1]).to have_text(
          t("#{i18n_prefix}.table.actions.delete_user")
        )
      end

      context 'target user is an leader' do
        before { user.add_role(:leader) }

        it 'generates the button to remove the target user as an leader' do
          actions = to_html_node(actions_for(user))
          buttons = actions.all('button')

          expect(buttons[0]).to have_text(
            t("#{i18n_prefix}.table.actions.remove_leader")
          )
        end
      end

      context 'current user is not an leader' do
        before { leader.remove_role(:leader) }

        it 'generates no buttons' do
          expect(actions_for(user)).to be_nil
        end
      end

      context 'target user is the current user' do
        let(:user) { leader }

        it 'generates no buttons' do
          expect(actions_for(user)).to be_nil
        end
      end
    end

    context 'target is a UserInvitation' do
      it 'generates the button to resend the invitation' do
        actions = to_html_node(actions_for(user_invitation))
        buttons = actions.all('button')

        expect(buttons[0]).to have_text(
          t("#{i18n_prefix}.table.actions.resend_invitation")
        )
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

      context 'target user is an leader' do
        it 'returns the leader label' do
          expect(role_for(leader)).to eq(I18n.t('roles.leader.label'))
        end
      end
    end

    context 'target is a UserInvitation' do
      it 'returns nil' do
        expect(role_for(user_invitation)).to be_nil
      end

      context '`UserInvitation#role` is present' do
        before { user_invitation.update!(role: 'manager') }

        it 'returns the role label' do
          expect(role_for(user_invitation)).to eq(I18n.t('roles.manager.label'))
        end
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
        expect(status_for(user_invitation)).to eq(
          t("#{i18n_prefix}.table.status.invited")
        )
      end
    end
  end

  def to_html_node(str)
    Capybara::Node::Simple.new(str)
  end
end
