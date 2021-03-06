require 'rails_helper'

RSpec.describe Admin::Audit::UserDescriptionService do
  describe '#description' do
    let(:user) { create(:user) }

    before { @i18n_prefix = 'admin.audit.user_description' }

    context 'user created as native' do
      let!(:user) { create(:user, :native) }

      it 'returns the correct description' do
        expect(description).to eq(t("#{@i18n_prefix}.created_as_native"))
      end
    end

    context 'user created as omniauth' do
      let!(:user) { create(:user, :omniauth, provider: provider) }
      let(:provider) { User::OMNIAUTH_PROVIDERS.first }

      it 'returns the correct description' do
        description =
          t("#{@i18n_prefix}.created_as_omniauth", provider: provider)
        expect(description).to eq(description)
      end
    end

    context 'user updated to deactivated' do
      before { user.update!(deactivated_at: Time.zone.now) }

      it 'returns the correct description' do
        description =
          t("#{@i18n_prefix}.updated_to_deactivated", email: user.email)
        expect(description).to eq(description)
      end
    end

    context 'user updated to activated' do
      let(:user) { create(:user, :deactivated) }

      before { user.update!(deactivated_at: nil) }

      it 'returns the correct description' do
        description =
          t("#{@i18n_prefix}.updated_to_activated", email: user.email)
        expect(description).to eq(description)
      end
    end

    context 'user updated to add role' do
      before { user.add_role(:director) }

      it 'returns the correct description' do
        description =
          t(
            "#{@i18n_prefix}.updated_to_add_role",
            name: user.name, role: :director
          )
        expect(description).to eq(description)
      end
    end

    context 'user updated to remove role' do
      before do
        user.add_role(:director)
        user.remove_role(:director)
      end

      it 'returns the correct description' do
        description =
          t(
            "#{@i18n_prefix}.updated_to_remove_role",
            name: user.name, role: :director
          )
        expect(description).to eq(description)
      end
    end
  end

  def call(audit = nil)
    Admin::Audit::UserDescriptionService.call(audit || Audited::Audit.last)
  end

  def description(audit = nil)
    Admin::Audit::UserDescriptionService.new(audit || Audited::Audit.last)
      .description
  end
end
