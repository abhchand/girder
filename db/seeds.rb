# Create a user
user = FactoryBot.create(
  :user,
  with_avatar: true,
  first_name: "Sindhu",
  last_name: "Iyer",
  email: "test@example.com",
  password: "test"
)

# Create photos
(1..10).each do |i|
  puts "Creating photo ##{i + 1}"
  FactoryBot.create(:photo, owner: user, taken_at: (10 * i).days.from_now)
end
