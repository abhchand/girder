module ApplicationHelper
  def current_user_presenter
    @current_user_presenter ||= begin
      UserPresenter.new(current_user, view: view_context) if current_user
    end
  end

  # Devise
  def devise_mapping
    Devise.mappings[:user]
  end

  # Devise automatically sets a flash `notice` on succesful sign in.
  # This hacky workaround removes the flash if it is set.
  def after_sign_in_path_for(resource)
    flash.delete(:notice) if flash[:notice] == t("devise.sessions.signed_in")
    super
  end

  # Devise automatically sets a flash `notice` on succesful sign out.
  # This hacky workaround removes the flash if it is set.
  def after_sign_out_path_for(resource)
    flash.delete(:notice) if flash[:notice] == t("devise.sessions.signed_out")
    super
  end

  def page_specific_css_id
    "#{params[:controller]}-#{params[:action]}".tr("_", "-")
  end

  def render_inside(opts = {}, &block)
    layout = opts.fetch(:parent_layout)

    layout = "layouts/#{layout}" unless layout.start_with?("layout")
    content_for(:nested_layout_content, capture(&block))
    render template: layout
  end

  def to_bool(value)
    ActiveRecord::Type::Boolean.new.deserialize(value)
  end
end
