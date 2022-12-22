require 'rails_helper'

RSpec.describe 'application/_desktop_navigation.html.erb', type: :view do
  let(:user) { create(:user) }

  before do
    @t_prefix = 'application.desktop_navigation'
    forward_can_method_to(user)
  end

  context 'user can access admin pages' do
    before { user.add_role(:admin) }

    it 'renders the admin index link' do
      render
      expect(rendered_links).to include(admin_index_path)
    end
  end

  def rendered_links
    [].tap do |links|
      page.all('.desktop-navigation__link-element').each do |el|
        links << el.find('a')['href']
      end
    end
  end
end
