FactoryBot.define do
  factory :user_invitation do
    sequence(:email) { |n| "email-#{n}@atl.gov" }
    inviter factory: :user

    trait :completed do
      invitee factory: :user
    end
  end
end
