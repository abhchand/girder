class SettingsController < ApplicationController
  include SettingsHelper

  layout 'with_responsive_navigation'

  before_action { @use_packs << 'settings' }

  def index
  end
end
