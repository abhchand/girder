class Devise::Custom::RegistrationsController < Devise::RegistrationsController
  include Devise::AuthHelper

  prepend_before_action :ensure_native_auth_enabled
  before_action { @use_packs << 'auth' }

  def create
    super do |new_user|
      next unless new_user.persisted?

      UserInvitations::RegistrationService.call(new_user)
      UserInvitation::MarkAsCompleteJob.perform_async(new_user.id)
    end
  end

  # Devise generates a route to edit registrations, but we'd rather
  # rather handle editing user/registration information through our
  # internal account page, so just blindly redirect there
  def edit
    redirect_to account_index_path
  end
end
