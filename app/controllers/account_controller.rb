class AccountController < ApplicationController
  include AccountHelper

  layout 'with_responsive_navigation'

  before_action { @use_packs << 'settings' }

  def index
    @user = current_user
    @user_json = serialize_current_user
  end
end
