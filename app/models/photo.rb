class Photo < ApplicationRecord
  include HasSyntheticId

  belongs_to :owner, class_name: 'User', inverse_of: :photos, validate: false

  validates :taken_at, presence: true

  before_validation :default_taken_at, on: :create

  private

  def default_taken_at
    return if taken_at.present?

    date = ActiveSupport::TimeZone['UTC'].now.strftime('%Y:%m:%d %H:%M:%S')
    self.taken_at = date
  end
end
