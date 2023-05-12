require 'rails_helper'

RSpec.describe 'settings/index.html.erb', type: :view do
  let(:user) { create(:user) }

  before { @t_prefix = 'settings.index' }

  it 'renders the settings links' do
    render

    actual_links = []
    expected_links = [settings_users_path]

    page
      .all('.settings-index__link-element')
      .each do |el|
        link = el.find('a')
        actual_links << link['href']
      end

    expect(expected_links).to eq(actual_links)
  end
end
