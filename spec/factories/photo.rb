FactoryBot.define do
  factory :photo do
    owner factory: :user
    taken_at { Time.zone.now }
  end
end
