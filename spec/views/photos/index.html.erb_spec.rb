require "rails_helper"

RSpec.describe "photos/index.html.erb", type: :view do
  let(:user) { create(:user) }
  let(:photos) { create_list(:photo, 2) }

  before do
    stub_view_context
    stub_template "shared/_photo_count.html.erb" => "_stubbed_photo_count"

    assign(:photos, photos)
    assign(:photo_count, photos.count)

    @t_prefix = "photos.index"
  end

  it "renders the photo count" do
    render
    expect(rendered).to have_content("_stubbed_photo_count")
  end

  it "renders each photo" do
    render

    photos.each do |photo|
      expect(page).to have_selector("li[data-id='#{photo.synthetic_id}']")
    end
  end

  context "no photos exist" do
    before do
      assign(:photos, [])
      assign(:photo_count, 0)
    end

    it "displays the empty state" do
      render

      expect(page.find(".photos-index__emtpy-state")).
        to have_content(t("#{@t_prefix}.empty"))

      expect(rendered).to_not have_content("_stubbed_photo_count")
    end
  end
end
