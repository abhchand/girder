class ExampleJob < ApplicationWorker
  def perform(user_id)
    @user = User.find(user_id)

    # Do stuff
  end
end
