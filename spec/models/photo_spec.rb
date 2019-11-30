require "rails_helper"
# rubocop:disable Metrics/LineLength
require Rails.root.join("spec/support/shared_examples/models/concerns/has_synthetic_id").to_s
# rubocop:enable Metrics/LineLength

RSpec.describe Photo, type: :model do
  let(:photo) { create(:photo) }

  it_behaves_like "has synthetic id"

  describe "Associations" do
    it { should belong_to(:owner) }
  end

  describe "Validations" do
    describe "#taken_at" do
      # `taken_at` is defaulted to a value if `nil`, so validating presence
      # incorrectly passes when it should fail. Since this defaulting is
      # only done `on: :create`, we can get around this by defining a
      # `subject` that is re-used and not defaulted beyond the first validation
      # on create.
      subject { photo }

      it { should validate_presence_of(:taken_at) }
    end
  end

  describe "callbacks" do
    describe "before_validation" do
      describe "#default_taken_at" do
        let(:photo) { create(:photo) }

        it "only runs on: :create" do
          expect do
            photo.taken_at = nil
          end.to change { photo.taken_at.nil? }.from(false).to(true)
        end

        it "sets the field as the current UTC time" do
          now = Time.zone.parse("2000-01-01 10:00:00")

          travel_to(now) do
            expect(photo.taken_at.strftime("%Y-%m-%d %H:%M:%S")).
              to eq("2000-01-01 10:00:00")
          end
        end

        context "taken_at is already populated" do
          it "does not override the existing value" do
            photo.update!(taken_at: "2019-03-14 13:00:00")

            expect(photo.taken_at.strftime("%Y-%m-%d %H:%M:%S")).
              to eq("2019-03-14 13:00:00")
          end
        end
      end
    end
  end
end
