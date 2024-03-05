# Dry Types are used to validate the type (and structure) of objects. They are
# particularly useful for validating options, config, or params hashes, but can
# be used generically in any situation.
#
# See: https://github.com/dry-rb/dry-types

# Define a top-level namespace to easily access dry-type's builtin types
#
#   User = Dry.Struct(name: DryTypes::String, age: DryTypes::Integer)
#   User.new(name: 'Anjali', age: 30)
module DryTypes
  include Dry.Types()
end
