class UserInvitationsController < ApplicationController
  before_action :ensure_json_request, only: %i[create destroy]

  def create
    authorize! :create, :user_invitation

    @user_invitation = create_service.user_invitation

    status, json =
      if create_service.success?
        UserInvitationMailer.delay.invite(@user_invitation.id)
        [200, @user_invitation]
      else
        [create_service.status, { error: create_service.error }]
      end

    create_service.log.tap { |msg| Rails.logger.debug(msg) if msg }

    respond_to { |format| format.json { render json: json, status: status } }
  end

  def destroy
    authorize! :destroy, user_invitation

    user_invitation.destroy!

    respond_to { |format| format.json { render json: {}, status: 200 } }
  end

  private

  def create_params
    params.require(:user_invitation).permit(:email)
  end

  def create_service
    @create_service ||=
      UserInvitations::CreateService.call(
        params: create_params,
        current_user: current_user
      )
  end
end
