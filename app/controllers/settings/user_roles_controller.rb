class Settings::UserRolesController < SettingsController
  before_action :ensure_json_request, only: %i[update]

  def update
    authorize! :update_role, user
    authorize! :promote, :superuser if roles.include?('superuser')

    update_service =
      Settings::UserRoles::UpdateService.call(
        current_user: current_user,
        user: user,
        roles: roles
      )

    status, json =
      if update_service.success?
        [200, {}]
      else
        [update_service.status, { error: update_service.error }]
      end

    update_service.log.tap { |msg| Rails.logger.debug(msg) if msg }

    respond_to { |format| format.json { render json: json, status: status } }
  end

  private

  def roles
    update_params[:roles]
  end

  def update_params
    params.permit(roles: [])
  end
end
