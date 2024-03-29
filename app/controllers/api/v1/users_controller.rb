class Api::V1::UsersController < Api::BaseController
  before_action :user, only: %i[show update destroy]

  def index
    authorize! :index, :users

    users = fetch_users
    users = search(users)

    # Order matters! We need to determine meta data *before* we
    # paginate the actual data set
    total = users.count
    links = pagination_links(users)

    users = paginate(users)

    json =
      serialize(
        users,
        links: links,
        meta: {
          totalCount: total
        }
      )

    render json: json, status: :ok
  end

  def show
    authorize! :show, user

    json = serialize(user)

    render json: json, status: :ok
  end

  def update
    authorize! :update, user

    user.attributes = update_params

    if user.save
      json = serialize(user)
      status = :ok
    else
      json = @user.serialize_errors
      status = :forbidden
    end

    render json: json, status: status
  end

  def destroy
    authorize! :destroy, user

    (head :bad_request and return) if user == current_user

    user.destroy!

    head :ok
  end

  def add_role
    authorize! :update_role, user

    # NOTE: Despite their name, `add_role` and `remove_role` only work with
    # updating a single role - `leader`.
    # TODO: Make this work generically with any `params[:role]` value, and
    # be sure to disallow updating to `:superuser`
    user.add_role(:leader)

    head :ok
  end

  def remove_role
    authorize! :update_role, user

    # NOTE: Despite their name, `add_role` and `remove_role` only work with
    # updating a single role - `leader`.
    # TODO: Make this work generically with any `params[:role]` value, and
    # be sure to disallow updating to `:superuser`
    user.remove_role(:leader)

    head :ok
  end

  private

  def update_params
    # We don't handle password updates here. See
    # `devise/custom/registrations#update` for that logic
    params.require(:user).permit(:first_name, :last_name, :avatar)
  end

  def fetch_users
    active = params[:active].present? ? to_bool(params[:active]) : true

    User.send(active ? :active : :deactivated).order(
      'lower(first_name), lower(last_name), lower(email)'
    )
  end

  def search(users)
    # FYI: Search logic will sanitize any input SQL in `params[:search]`
    Users::SearchService.perform(users, params[:search])
  end

  def serialize(user, opts = {})
    serialize_user(user, opts)
  end
end
