if defined?(Pry)
  color_start = color_end = ''

  if Pry.config.color
    # Red for Production, Green otherwise.
    color_start = Rails.env.production? ? "\033[31m" : "\033[32m"
    color_end = "\033[0m"
  end

  application =
    # rubocop:disable Style/StringConcatenation
    "\033[33m" + Rails.application.class.name.split('::').first + "\033[0m"
  # rubocop:enable Style/StringConcatenation

  Pry.config.prompt_name =
    "pry|#{application}|#{color_start}#{Rails.env}#{color_end}"
end
