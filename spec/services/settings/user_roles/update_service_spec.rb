require 'rails_helper'

RSpec.describe Settings::UserRoles::UpdateService, type: :interactor do
  let(:current_user) { create(:user) }
  let(:user) { create(:user) }

  before do
    stub_const('Role::ALL_ROLES', %w[manager director leader])

    @i18n_prefix = 'settings.user_roles.update_service'
  end

  describe 'adding roles' do
    before { user.add_role(:leader) }

    it 'adds any necessary roles to the user' do
      result = call(roles: %w[leader manager])

      expect(result.success?).to eq(true)

      expect(user.reload.roles.pluck(:name)).to match_array(%w[leader manager])

      expect(result.error).to be_nil
      expect(result.log).to be_nil
      expect(result.status).to be_nil
    end
  end

  describe 'removing roles' do
    before do
      user.add_role(:leader)
      user.add_role(:manager)
    end

    it 'removes any necessary roles to the user' do
      result = call(roles: %w[manager])

      expect(result.success?).to eq(true)

      expect(user.reload.roles.pluck(:name)).to match_array(%w[manager])

      expect(result.error).to be_nil
      expect(result.log).to be_nil
      expect(result.status).to be_nil
    end
  end

  it 'can remove all roles if needed' do
    user.add_role(:leader)
    user.add_role(:manager)
    result = call(roles: %w[])

    expect(result.success?).to eq(true)

    expect(user.reload.roles.pluck(:name)).to match_array(%w[])

    expect(result.error).to be_nil
    expect(result.log).to be_nil
    expect(result.status).to be_nil
  end

  it 'correctly handles duplicate roles' do
    user.add_role(:leader)

    result = call(roles: %w[leader manager manager])

    expect(result.success?).to eq(true)

    expect(user.reload.roles.pluck(:name)).to match_array(%w[leader manager])

    expect(result.error).to be_nil
    expect(result.log).to be_nil
    expect(result.status).to be_nil
  end

  context 'one ore more roles are invalid' do
    it 'does not update any roles' do
      user.add_role(:leader)

      result = call(roles: %w[leader manager foo])

      expect(result.success?).to eq(false)

      expect(user.reload.roles.pluck(:name)).to match_array(%w[leader])

      expect(result.error).to eq(I18n.t("#{@i18n_prefix}.invalid_roles"))
      expect(result.log).to_not be_nil
      expect(result.status).to eq(400)
    end
  end

  def call(opts = {})
    Settings::UserRoles::UpdateService.call(
      { current_user: current_user, user: user, roles: [] }.merge(opts)
    )
  end
end
