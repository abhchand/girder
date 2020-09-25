require 'rails_helper'

RSpec.feature 'Example Component', type: :feature do
  let(:user) { create(:user) }
  let!(:photos) { create_list(:photo, 2, owner: user) }

  before { log_in(user) }

  it 'renders each photo', :js do
    photos.each do |photo|
      expect(page).to have_selector("li[data-id='#{photo.synthetic_id}']")
    end
  end
end
