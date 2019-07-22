require "rails_helper"

RSpec.feature "Logging In", type: :feature do
  let(:user) { create(:user, password: password) }
  let(:password) { "kingK0ng" }

  before { user }

  it "user can log in" do
    visit root_path

    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: password
    click_submit

    expect(page).to have_current_path(photos_path)
  end

  it "preserves user destination for deep-linking" do
    visit settings_path

    expect(current_path).to eq(root_path)
    expect(url_params[:dest]).to eq(settings_path)

    # Failed Login Attempt

    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: "badPassword"
    click_submit

    expect(current_path).to eq(root_path)
    expect(url_params[:dest]).to eq(settings_path)

    # Successful Login Attempt

    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: password
    click_submit

    expect(page).to have_current_path(settings_path)
  end

  describe "form validation" do
    it "user receives form validation on submit" do
      visit root_path

      click_submit

      expect(find(".flash__message")).
        to have_content(t("sessions.create.authenticate.blank_email"))
    end
  end

  def click_submit
    click_button(t("site.index.form.submit"))
  end
end
