namespace :girder do
  namespace :admin do
    desc 'Create a new Girder admin'
    task :create,
         %i[fname lname email password] => %i[environment] do |_t, args|
      attrs = {
        first_name: args[:fname],
        last_name: args[:lname],
        email: args[:email],
        password: args[:password]
      }

      user = User.new(attrs)
      user.save!
      user.add_role(:admin)
    end
  end
end
