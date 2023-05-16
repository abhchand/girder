USER_ROLES =
  if Rails.env.test?
    %w[superuser leader manager director].freeze
  else
    %w[superuser leader].freeze
  end
