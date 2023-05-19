class UserSerializer < ApplicationSerializer
  set_id :synthetic_id
  attributes :first_name, :last_name, :email, :last_sign_in_at

  attribute(:avatar) { |user| UserPresenter.new(user, view: nil).avatar }

  attributes :user_roles do |user, _params|
    u = user.is_a?(UserPresenter) ? user : UserPresenter.new(user, view: nil)
    u.roles
  end

  link :self do |user, _params|
    Rails.application.routes.url_helpers.api_v1_user_url(user)
  end
end
