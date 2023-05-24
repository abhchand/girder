require 'rails_helper'

RSpec.feature 'Editing User Avatar', type: :feature, js: true do
  include WebpackHelper

  let(:user) { create(:user, with_avatar: false) }

  it 'user can create and update the avatar' do
    log_in(user)

    visit account_profile_index_path

    expect_blank_avatar

    # Select a file for upload. We don't edit the image at all since interacting
    # with the image cropper is not easy via Capybara
    select_file('chennai.jpg')
    submit!

    expect_avatar('chennai.jpg')
  end

  context 'error updating avatar' do
    before do
      expect_any_instance_of(Api::V1::UsersController).to receive(
        :update_params
      ).and_raise('boo!')
    end

    it 'user can exit the process' do
      log_in(user)

      visit account_profile_index_path

      select_file('chennai.jpg')
      click_modal_submit
      wait_for_async_process('modal-submit')

      # Should display generic error
      expect(page.find('.modal--error')).to have_text(I18n.t('generic_error'))

      # Should be able to close modal and exit the process
      click_modal_close
      expect_modal_is_closed
    end
  end

  def displayed_avatar_path
    # The image src is returned as a full URL
    #   http://{capybara-host}:{capybara-port}/path/to/file
    #
    # As a cheap workaround, we `split()` on the port and grab the second half
    # of the URL representing the path
    page.find('.avatar-editor__avatar')['src']&.split(
      Capybara.current_session.server.port.to_s
    )&.last
  end

  def expect_blank_avatar
    user.reload
    expect(user.avatar.attached?).to eq(false)
    expect(displayed_avatar_path).to eq(image_path('blank-avatar.jpg'))
  end

  def expect_avatar(fixture)
    user.reload

    expect(user.avatar.attached?).to eq(true)
    expect(user.avatar_blob.filename).to eq(fixture)

    # We can't easily derive the URL of the new image source, but we know it
    # will contain the blob `signed_id`, so just check for that
    expect(displayed_avatar_path).to match(user.avatar_blob.signed_id)
  end

  def select_file(fixture)
    attach_file(
      'user[avatar]',
      fixture_path_for("images/#{fixture}"),
      visible: false
    )
  end

  def submit!
    prev_path = displayed_avatar_path

    click_modal_submit

    # Wait for the image to change so we can tell the page has reloaded
    wait_for { displayed_avatar_path && displayed_avatar_path != prev_path }
  end
end
