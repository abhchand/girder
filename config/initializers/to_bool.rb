class Object
  # Convenience method for any Object
  def to_bool
    ActiveModel::Type::Boolean.new.cast(self)
  end
end
