require 'rails_helper'

RSpec.feature 'Mobile Header', type: :feature do
  let(:user) { create(:user) }

  before { @t_prefix = 'application.mobile_header' }

  context 'mobile', :mobile, js: true do
    context 'dropdown menu' do
      it 'user can open the dropdown and click a link' do
        log_in(user)
        expect_mobile_dropdown_is_closed

        click_mobile_dropdown_icon
        expect_mobile_dropdown_is_open

        click_link(t("#{@t_prefix}.links.log_out"))
        expect(page).to have_current_path(new_user_session_path)
      end

      describe 'closing the dropdown' do
        before do
          log_in(user)
          click_mobile_dropdown_icon
          expect_mobile_dropdown_is_open
        end

        it 'user can close the dropdown by clicking the close button' do
          find('.mobile-header-dropdown__close').click
          expect_mobile_dropdown_is_closed
        end

        it 'user can close the dropdown by clicking the overlay' do
          # The overlay is 400x730 in size (100% filling the mobile window)
          # `click` by default clicks on the center of the element (200, 365). But
          # the overlay is covered by the menu itself and is not clickable at its
          # midpoint.
          #
          # So we manually specify a coordinate *offset* relative to the
          # midpoint to click on: 150px to the right
          find('.mobile-header-dropdown__overlay').click(x: 150, y: 0)
          expect_mobile_dropdown_is_closed
        end
      end
    end
  end
end
