require 'rails_helper'

RSpec.feature 'creating product feedback', type: :feature do
  let(:user) { create(:user) }

  before do
    log_in(user)
    visit user.signed_in_path
  end

  it 'user can leave product feedback', :js do
    open_feedback_modal_on_desktop
    fill_in('product_feedback[body]', with: 'Some feedback')

    click_modal_submit
    wait_for { ProductFeedback.count == 1 }

    pf = ProductFeedback.last
    expect(pf.user).to eq(user)
    expect(pf.body).to eq('Some feedback')

    expect_modal_is_closed
  end

  it 'validates the feedback', :js do
    open_feedback_modal_on_desktop
    fill_in('product_feedback[body]', with: '')

    click_modal_submit

    message = validation_error_for(:body, :blank, klass: ProductFeedback)
    expect(modal_error).to eq(message)
  end

  context 'mobile', :mobile, js: true do
    it 'user can leave product feedback' do
      open_feedback_modal_on_mobile
      expect_mobile_dropdown_is_closed

      fill_in('product_feedback[body]', with: 'Some feedback')

      click_modal_submit
      wait_for { ProductFeedback.count == 1 }

      pf = ProductFeedback.last
      expect(pf.user).to eq(user)
      expect(pf.body).to eq('Some feedback')

      expect_modal_is_closed
    end
  end

  def open_feedback_modal_on_desktop
    toggle_desktop_account_dropdown
    expect_desktop_account_dropdown_is_open

    page.find(
      '.desktop-header-account-dropdown__link-element--product-feedback'
    ).click
    expect_modal_is_open
  end

  def open_feedback_modal_on_mobile
    click_mobile_dropdown_icon
    page.find('.mobile-header-dropdown__link-element--product-feedback').click
    expect_modal_is_open
  end
end
