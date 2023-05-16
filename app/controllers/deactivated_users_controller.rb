class DeactivatedUsersController < ApplicationController
  skip_before_action :check_if_deactivated, only: %i[index]

  before_action :ensure_json_request, only: %i[destroy]
  before_action { @use_packs << 'auth' }

  def index
    # In case someone visits this URL directly without truly
    # being deactivated :)
    redirect_to(root_path) unless current_user.deactivated?
  end

  # "destroying" a deactivated user amounts to reactivating the user (i.e.
  # eliminating the deactivated status). This endpoint would ideally be called
  # `activate` but going with `destroy` to keep the naming/action consistent
  # with the UsersController (e.g. "destroying" a user creates a deactivated
  # user)
  def destroy
    # The `:destroy` ability here refers to destroy an *active* user. We assume
    # if you can destroy an active user, you can also destroy (i.e. re-activate)
    # a deactivated user.
    authorize! :destroy, user

    user.update!(deactivated_at: nil) if user.deactivated?

    respond_to { |format| format.json { render json: {}, status: 200 } }
  end
end
