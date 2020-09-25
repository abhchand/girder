require 'rails_helper'

RSpec.describe 'photos/index.html.erb', type: :view do
  let(:user) { create(:user) }
  let(:photos) { create_list(:photo, 2) }

  before do
    stub_view_context
    stub_template 'layouts/_flash.html.erb' => '_stubbed_flash'
    stub_template 'shared/_photo_count.html.erb' => '_stubbed_photo_count'

    assign(:photos, photos)
    assign(:photo_count, photos.count)

    @t_prefix = 'photos.index'
  end

  it 'renders the flash' do
    render
    expect(rendered).to have_content('_stubbed_flash')
  end

  it 'renders the photo count' do
    render
    expect(rendered).to have_content('_stubbed_photo_count')
  end

  it 'renders the example component' do
    render

    photo_props =
      PhotoPresenter.wrap(photos, view: view_context).map(&:photo_grid_props)

    expect(page).to have_react_component('example').including_props(
      photos: photo_props
    )
  end

  context 'no photos exist' do
    before do
      assign(:photos, [])
      assign(:photo_count, 0)
    end

    it 'displays the empty state' do
      render

      expect(page.find('.photos-index__emtpy-state')).to have_content(
        t("#{@t_prefix}.empty")
      )

      expect(rendered).to_not have_content('_stubbed_photo_count')
    end
  end
end
