class UserInvitation < ApplicationRecord
  belongs_to :inviter, class_name: 'User', validate: false

  validates :email, presence: true, uniqueness: true
  validates :inviter_id, presence: true

  before_save { self[:email].downcase! if self[:email].present? }
end
