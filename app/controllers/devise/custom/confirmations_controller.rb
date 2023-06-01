class Devise::Custom::ConfirmationsController < Devise::ConfirmationsController
  include Devise::AuthHelper

  prepend_before_action :force_authenticate_user!, only: %i[new]
  prepend_before_action :ensure_native_auth_enabled
  before_action :ensure_user_is_unconfirmed, only: %i[new]
  before_action { @use_packs << 'auth' }

  # By default the `:new` action is available without signing in. We override
  # the action authorization to have it only be accsssible *after* signing in,
  # and only by unconfirmed users.
  #
  # The `root#new` logic for routing users sends any unconfirmed users here.
  def new
    # By default, Devise sets `@user` as `User.new` since the page is not
    # authenticated.
    @user = current_user
  end

  private

  def ensure_user_is_unconfirmed
    redirect_to(root_path) if current_user.confirmed?
  end
end
