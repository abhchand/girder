class Api::V1::UserInvitationsController < Api::BaseController
  def index
    authorize! :index, :user_invitations

    user_invitations = UserInvitation.order('lower(email)')
    user_invitations = search(user_invitations)

    # Order matters! We need to determine meta data *before* we
    # paginate the actual data set
    total = user_invitations.count
    links = pagination_links(user_invitations)

    user_invitations = paginate(user_invitations)

    json =
      serialize(user_invitations, links: links, meta: { totalCount: total })

    render json: json, status: :ok
  end

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

  def resend
    authorize! :create, :user_invitation

    UserInvitationMailer.delay.invite(user_invitation.id)

    head :ok
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

  def search(user_invitations)
    # FYI: Search logic will sanitize any input SQL in `params[:search]`
    UserInvitations::SearchService.perform(user_invitations, params[:search])
  end

  def serialize(user, opts = {})
    UserInvitationSerializer.new(
      user,
      { params: {} }.deep_merge(opts)
    ).serializable_hash
  end
end
