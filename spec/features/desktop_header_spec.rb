require 'rails_helper'

RSpec.feature 'Desktop Header', type: :feature do
  let(:user) { create(:user) }

  before { @t_prefix = 'application.desktop_header' }

  context 'account dropdown menu', js: true do
    it 'user can toggle the dropdown and click a link' do
      log_in(user)
      expect_desktop_account_dropdown_is_closed

      toggle_desktop_account_dropdown
      expect_desktop_account_dropdown_is_open

      toggle_desktop_account_dropdown
      expect_desktop_account_dropdown_is_closed

      toggle_desktop_account_dropdown
      click_link(t("#{@t_prefix}.links.log_out"))
      expect(page).to have_current_path(new_user_session_path)
    end

    describe 'closing the dropdown' do
      before do
        log_in(user)
        toggle_desktop_account_dropdown
        expect_desktop_account_dropdown_is_open
      end

      it 'user can close the dropdown by clicking outside the dropdown' do
        page.find('.responsive-navigation-content').click
        expect_desktop_account_dropdown_is_closed
      end

      it 'user can close the dropdown by pressing ESCAPE' do
        page.find('body').base.send_keys(:escape)
        expect_desktop_account_dropdown_is_closed
      end
    end
  end
end
