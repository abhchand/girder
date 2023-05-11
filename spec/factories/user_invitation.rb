FactoryBot.define do
  factory :user_invitation do
    sequence(:email) { |n| "email-#{n}@atl.gov" }
    inviter factory: :user
  end
end
