class UserInvitation < ApplicationRecord
  belongs_to :inviter, class_name: 'User', validate: false
  belongs_to :invitee,
             class_name: 'User',
             inverse_of: :invitation,
             validate: false,
             optional: true

  validates :email, presence: true, uniqueness: true
  validates :inviter_id, presence: true
  validates :invitee_id, uniqueness: true, allow_nil: true
  before_save { self[:email].downcase! if self[:email].present? }

  scope :pending, -> { where(invitee: nil) }
  scope :completed, -> { where.not(invitee: nil) }

  def pending?
    invitee.blank?
  end

  def completed?
    invitee.present?
  end
end
