module FeatureHelpers
  #
  # Desktop (Account Dropdown)
  #

  def toggle_desktop_account_dropdown
    find('.desktop-header__profile-pic').click
    wait_for_ajax
  end

  def expect_desktop_account_dropdown_is_closed
    wait_for_ajax
    expect(page).to have_selector(
      '.desktop-header-account-dropdown.inactive',
      visible: false
    )
  end

  def expect_desktop_account_dropdown_is_open
    wait_for_ajax
    expect(page).to have_selector('.desktop-header-account-dropdown.active')
  end

  #
  # Mobile
  #

  def click_mobile_dropdown_icon
    find('.mobile-header__menu-icon').click
    wait_for_ajax
  end

  def expect_mobile_dropdown_is_closed
    wait_for_ajax

    expect(page).to have_selector('.mobile-header-dropdown.inactive')
    expect(page).to have_selector(
      '.mobile-header-dropdown__overlay',
      visible: false
    )
  end

  def expect_mobile_dropdown_is_open
    wait_for_ajax

    expect(page).to have_selector('.mobile-header-dropdown.active')
    expect(page).to have_selector('.mobile-header-dropdown__overlay')
  end
end
