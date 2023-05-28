class Devise::Custom::RegistrationsController < Devise::RegistrationsController
  include Devise::AuthHelper

  prepend_before_action :ensure_native_auth_enabled
  before_action { @use_packs << 'auth' }

  def create
    super do |new_user|
      if new_user.persisted?
        UserInvitations::RegistrationService.call(new_user)
        UserInvitation::MarkAsCompleteJob.perform_async(new_user.id)
      else
        # Errors related to `encrypted_password` don't matter to the end user
        new_user.errors.delete(:encrypted_password)
      end
    end
  end

  def update
    # Override the devise parent method that handles updates to the password
    # (and other attributes by default). We do this so that we can return
    # custom JSON when `format: 'json'` is specified. This ensurs that errors
    # are consistently serialized with `ApplicationRecord#serialize_errors`.

    super do |user|
      next unless params[:format] == 'json'

      if user.errors.empty?
        json = {}
        status = :ok
      else
        json = user.serialize_errors
        status = :bad_request

        clean_up_passwords(user)
        set_minimum_password_length
      end

      render json: json, status: status

      # `return` from the block so we don't continue execution in the parent
      return
    end
  end

  # Devise generates a route to edit registrations, but we'd rather
  # rather handle editing user/registration information through our
  # internal account page, so just blindly redirect there
  def edit
    redirect_to account_index_path
  end

  private

  # Overrides the devise parent to permit only password related params. The
  # parent generically allows any params, but we handle other updates to `User`
  # in `api/v1/users#update`
  def account_update_params
    params.require(:user).permit(
      :current_password,
      :password,
      :password_confirmation
    )
  end
end
