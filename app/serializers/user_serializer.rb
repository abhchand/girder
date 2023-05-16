class UserSerializer < ApplicationSerializer
  set_id :synthetic_id
  attributes :first_name, :last_name, :email, :last_sign_in_at

  attribute(:avatar) { |user| UserPresenter.new(user, view: nil).avatar }

  # Below attributes are only available when the `user` is wrapped in
  # a `UserPresenter`
  attributes :roles, if: proc { |user, _params| user.respond_to?(:roles) }

  link :self do |user, _params|
    Rails.application.routes.url_helpers.api_v1_user_url(user)
  end
end
