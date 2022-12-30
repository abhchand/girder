module UserHelper
  def user
    @user ||=
      User
        .find_by_synthetic_id(params[:id])
        .tap { |u| handle_user_not_found if u.blank? }
  end

  def only_editable_users
    return if can?(:write, user)

    handle_user_not_editable
  end

  def handle_user_not_found
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: { error: 'User not found' }, status: 404 }
    end
  end

  def handle_user_not_editable
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json do
        render json: { error: 'Insufficent permission' }, status: 403
      end
    end
  end
end
