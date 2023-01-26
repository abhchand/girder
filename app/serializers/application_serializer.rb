class ApplicationSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  # Serializer options are used to define rendering behavior, like what
  # associations to include and what fields to include on certain resource types
  # in the final serialized JSON/hash.
  #
  # The `fast_jsonapi` gem views these as view-level options, to be specified at
  # the time of rendering. However it is convenient for us to define a default
  # set of options in some cases.
  #
  # This overrides the initializer to use the options defined in
  # `DEFAULT_OPTIONS`, if one exists for that class.
  #
  # You can always pass in an explicit options hash that will override the
  # default, if desired.
  #
  # @example
  #
  # A Movie `has_many` Actors (class type `User`). In a `MovieSerializer` you
  # may define
  #
  #   class MovieSerializer < ApplicationSerializer
  #     DEFAULT_OPTIONS = {
  #       include: %i[actors],
  #       fields: { user: [:firstName] }
  #     }
  #
  #     has_many :actors, serializer: :user
  #   end
  #
  # Then call:
  #
  #   MovieSerializer.new(@movie).serializable_hash           # Use defaults
  #   MovieSerializer.new(@movie, { ... }).serializable_hash  # Override options
  #
  def initialize(resource, opts = nil)
    if opts.nil? && self.class.const_defined?('DEFAULT_OPTIONS')
      opts = self.class::DEFAULT_OPTIONS
    end

    super(resource, opts || {})
  end
end
