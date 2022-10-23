module HelperHelpers
  def stub_current_user(current_user = user)
    allow_any_instance_of(Object).to receive(:current_user) { current_user }
  end
end
