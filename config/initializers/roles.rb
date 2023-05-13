USER_ROLES =
  Rails.env.test? ? %w[leader manager director].freeze : %w[leader].freeze
