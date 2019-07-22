class SettingsController < ApplicationController
  layout "with_responsive_navigation"

  def index
    @name = current_user.name
  end
end
