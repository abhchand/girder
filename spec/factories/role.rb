FactoryBot.define do
  factory :role do
    name { Role::ALL_ROLES.first }
  end
end
