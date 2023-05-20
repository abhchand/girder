module SerializationHelper
  def serialize_current_user(family = nil)
    UserSerializer.new(
      current_user,
      { params: { family: family } }
    ).serializable_hash
  end

  def serialize_user(user, opts = {})
    UserSerializer.new(user, opts).serializable_hash
  end
end
