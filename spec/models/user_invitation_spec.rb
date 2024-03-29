require 'rails_helper'

RSpec.describe User do
  subject { build(:user_invitation) }
  # let(:user_invitation) { subject }

  describe 'Associations' do
    it { should belong_to(:inviter) }
  end

  describe 'Validations' do
    describe '#email' do
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email) }
    end

    describe '#inviter_id' do
      it { should validate_presence_of(:inviter_id) }
      it { should_not validate_uniqueness_of(:inviter_id) }
    end

    describe '#role' do
      it { should_not validate_presence_of(:role) }
      it { should validate_inclusion_of(:role).in_array(USER_ROLES).allow_nil }
    end
  end

  describe 'Callbacks' do
    describe '#before_save' do
      describe '#email' do
        it 'downcases the email' do
          invitation = build(:user_invitation, email: 'SOME_EMAIL@FOO.COM')

          invitation.save

          expect(invitation).to be_valid
          expect(invitation.email).to eq('some_email@foo.com')
        end

        it "doesn't error on blank emails" do
          invitation = build(:user_invitation, email: nil)
          expect { invitation.save }.to_not raise_error
        end
      end
    end
  end
end
