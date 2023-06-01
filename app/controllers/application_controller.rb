class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SerializationHelper
  include WebpackHelper

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :check_if_deactivated
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :append_view_paths
  before_action :initialize_packs_list
  before_action :set_default_pack

  helper_method :view_context

  unless Rails.env.development?
    rescue_from Exception do |exception|
      respond_to do |format|
        format.html { render plain: '500 Internal Server Error', status: 500 }

        format.json do
          error = { title: 'An unknown error occurred', status: '500' }
          render json: { errors: [error] }, status: 500
        end
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
      respond_to do |format|
        format.html { render plain: '404 Not Found', status: 404 }

        format.json do
          error = {
            title: 'Not Found',
            description: exception.message,
            status: '404'
          }
          render json: { errors: [error] }, status: 404
        end
      end
    end

    rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.html { render plain: '403 Forbidden', status: 403 }

        format.json do
          error = { title: 'Forbidden', status: '403' }
          render json: { errors: [error] }, status: 403
        end
      end
    end
  end

  private

  def user
    @user ||=
      User.find_by_synthetic_id!(params[:user_invitation_id] || params[:id])
  end

  def user_invitation
    @user_invitation ||=
      UserInvitation.find(params[:user_invitation_id] || params[:id])
  end

  def ensure_json_request
    return if defined?(request) && request.format.to_sym == :json
    redirect_to(root_path)
  end

  def append_view_paths
    append_view_path 'app/views/application'
  end

  def initialize_packs_list
    @use_packs = []
  end

  def set_default_pack
    @use_packs << 'common'

    # This pack should only be included in the test environment. It includes
    # JQuery so the Capybara tests can use it
    @use_packs << 'jquery-for-test' if Rails.env.test?
  end

  def verifier
    @verifier ||=
      ActiveSupport::MessageVerifier.new(
        Rails.application.secrets[:secret_key_base]
      )
  end

  # Devise calls `authenticate_user!` but skips actually authenticating users
  # in some instances where we might want to enforce authentication.
  # Use this `before_action` to foce authentication.
  def force_authenticate_user!
    authenticate_user!(force: true)
  end

  protected

  def check_if_deactivated
    return unless user_signed_in? && current_user.deactivated?

    respond_to do |format|
      format.json { render json: { error: 'User is deactivated' }, status: 403 }
      format.html { redirect_to(deactivated_users_path) }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end
end
