class Role < ApplicationRecord
  RESOURCE_TYPES = Rolify.resource_types
  ALL_ROLES = [USER_ROLES].flatten.uniq.freeze

  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true, optional: true

  validates :name, inclusion: { in: ALL_ROLES }
  validates :resource_type, inclusion: { in: RESOURCE_TYPES }, allow_nil: true

  scopify
end
