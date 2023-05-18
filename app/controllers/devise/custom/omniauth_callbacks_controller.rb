class Devise::Custom::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    unless provider_google_oauth2_enabled?
      redirect_to(new_user_session_path)
      return
    end

    Rails.logger.info("Google OAuth2 Omniauth for #{auth&.uid}")

    service = UserManagement::Omniauth::GoogleOauth2Service.call(auth: auth)
    service.log.tap { |msg| Rails.logger.debug(msg) if msg }

    if service.success?
      user = service.user
      after_registration(user) if service.was_user_created
      sign_in_and_redirect(user)
    else
      flash[:error] = service.error
      redirect_to(new_user_session_path)
    end
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end

  def after_registration(new_user)
    UserInvitations::RegistrationService.call(new_user)
    UserInvitation::MarkAsCompleteJob.perform_async(new_user.id)
  end
end
