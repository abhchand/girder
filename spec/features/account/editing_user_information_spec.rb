require 'rails_helper'

RSpec.feature 'Editing User Information', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:i18n_prefix) { 'account.index' }

  it 'user can update their name' do
    user.update!(first_name: 'Alonso', last_name: 'Harris')

    log_in(user)

    visit account_index_path

    # Unsuccessful Submit

    fill_in('user[first_name]', with: 'Shakuntala')
    fill_in('user[last_name]', with: '')

    page.find(".account__update-user-form input[type='submit']").click
    wait_for_async_process('api-post-request')

    expect(page).to have_flash_message(
      validation_error_for(:last_name, :blank)
    ).of_type(:error)

    # Successful Submit

    fill_in('user[first_name]', with: 'Shakuntala')
    fill_in('user[last_name]', with: 'Devi')

    page.find(".account__update-user-form input[type='submit']").click
    wait_for_async_process('api-post-request')

    expect(page).to have_flash_message(
      t("#{i18n_prefix}.form.confirmation")
    ).of_type(:notice)

    # Verify

    expect(user.reload.name).to eq('Shakuntala Devi')
  end

  it 'user can update their password' do
    log_in(user)

    visit account_index_path

    # Unsuccessful Submit
    fill_in('user[current_password]', with: FeatureHelpers::DEFAULT_PASSWORD)
    fill_in('user[password]', with: 'testAccount#1000')
    fill_in('user[password_confirmation]', with: '')

    page.find(".account__update-password-form input[type='submit']").click
    wait_for_async_process('api-post-request')

    expect(page).to have_flash_message(
      validation_error_for(:password_confirmation, :confirmation)
    ).of_type(:error)

    # Successful Submit

    fill_in('user[current_password]', with: FeatureHelpers::DEFAULT_PASSWORD)
    fill_in('user[password]', with: 'testAccount#1000')
    fill_in('user[password_confirmation]', with: 'testAccount#1000')

    page.find(".account__update-password-form input[type='submit']").click
    wait_for_async_process('api-post-request')

    expect(page).to have_flash_message(
      t("#{i18n_prefix}.form.confirmation")
    ).of_type(:notice)

    # Verify

    expect(user.reload.valid_password?('testAccount#1000')).to eq(true)
  end
end
