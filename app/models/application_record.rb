class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def serialize_errors
    errors_json = []

    # `ActiveModel::Errors` makes 2 methods available:
    #   * `#full_messages` returns the field name + message
    #     -> ['Last Name Please provide a last name']
    #   * `#messages` returns a key-value hash
    #     -> { last_name: ['Please provide a last name'] }
    #
    # Given the way we phrase I18n messages, the latter makes sense.
    errors.messages.values.flatten.each do |message|
      # NOTE: Errors not visible to end users are not translated
      # so we don't translate `:title`
      # Also, ActiveRecord generates `full_messages` by concatenating
      # the field name with the message, so the first word should always
      # be the field name
      errors_json << {
        title: "Invalid #{message.split(' ').first}",
        description: message,
        status: '403'
      }
    end

    { errors: errors_json, status: '403' }
  end
end
