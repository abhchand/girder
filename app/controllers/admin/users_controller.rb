class Admin::UsersController < AdminController
  def index
    active_users = User.order(:first_name, :last_name, :email)
    invited_users = UserInvitation.order(:email)

    @users = (invited_users + active_users)
  end
end
