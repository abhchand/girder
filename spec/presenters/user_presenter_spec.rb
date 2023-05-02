require 'rails_helper'

RSpec.describe PhotoPresenter, type: :presenter do
  let(:model) { create(:user) }
  let(:user) { UserPresenter.new(model, view: view_context) }

  describe '#avatar' do
    let(:model) { create(:user, with_avatar: true) }

    before do
      # Stub avatar sizes for consistent testing
      stub_const('User::AVATAR_SIZES', { thumb: { resize: '75x75' } })
    end

    it 'returns the avatar urls' do
      expect(user.avatar).to eq(
        {
          type: 'image',
          url: {
            original: url_for(model.avatar),
            thumb: url_for(model.avatar.variant(resize: '75x75'))
          }
        }
      )
    end

    context 'no avatar attached' do
      let(:model) { create(:user) }

      it 'returns the default blank avatars' do
        expect(user.avatar).to eq(
          {
            type: 'image',
            url: {
              original: image_path('blank-avatar.jpg'),
              thumb: image_path('blank-avatar-thumb.jpg')
            }
          }
        )
      end
    end
  end

  def url_for(resource)
    Rails.application.routes.url_helpers.url_for(resource)
  end
end
