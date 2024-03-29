class User < ApplicationRecord
  AVATAR_SIZES = {
    thumb: {
      resize: '75x75'
    },
    medium: {
      resize: '200x200'
    }
  }.freeze

  OMNIAUTH_PROVIDERS = %w[google_oauth2].freeze

  devise :database_authenticatable,
         :confirmable,
         :recoverable,
         :registerable,
         :timeoutable,
         :trackable,
         :validatable,
         :omniauthable,
         omniauth_providers: OMNIAUTH_PROVIDERS

  rolify

  include HasSyntheticId

  has_many :photos,
           foreign_key: :owner_id,
           dependent: :destroy,
           inverse_of: :owner

  has_one_attached :avatar

  # NOTE: Devise `authenticatable:`, `:database_authenticatable`,
  # `:validatable`, `::confirmable`, and `:recoverable` modules add other
  # validations for fields, particularly :email and :password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :sign_in_count, presence: true
  validates :provider, inclusion: { in: OMNIAUTH_PROVIDERS }, allow_blank: true

  validate :email_domain

  with_options if: :native? do |native|
    native.validates :encrypted_password, presence: true
    native.validates :uid, absence: true

    native.validate :additional_password_requirements
    native.validate :encrypted_password_is_valid_bcrypt_hash
  end

  with_options if: :omniauth? do |omniauth|
    omniauth.validates :password, absence: true
    omniauth.validates :encrypted_password, absence: true
    omniauth.validates :reset_password_token, absence: true
    omniauth.validates :reset_password_sent_at, absence: true
    omniauth.validates :confirmation_token, absence: true
    omniauth.validates :confirmed_at, absence: true
    omniauth.validates :confirmation_sent_at, absence: true
    omniauth.validates :uid,
                       presence: true,
                       uniqueness: {
                         case_sensitive: false
                       }
  end

  # Override default Devise behavior. We want to skip sending confirmation for
  # omniauth logins since we assume the third party service has already
  # verified this.
  after_create :skip_confirmation_notification!, if: :omniauth?

  scope :active, -> { where(deactivated_at: nil) }
  scope :deactivated, -> { where.not(deactivated_at: nil) }

  # Override Devise's implementation of this method which relies on
  # enqueuing mailers through ActiveJob. Below uses Sidekiq's ActionMailer
  # extensions (e.g. `deliver_later`) instead.
  def send_devise_notification(notification, *args)
    message = devise_mailer.send(notification, self, *args)
    message.deliver_later
  end

  # Override Devise's implementation of this method which blindly sends
  # reset password emails to all auth types. We should never attempt to send
  # a password reset to an omniauth account, and if we do we want to flag it
  # as a validation error so that the subsequent response can display it
  # in a flash or auth error.
  def send_reset_password_instructions
    if omniauth?
      provider = User.human_attribute_name("omniauth_provider.#{self.provider}")
      errors.add(:base, :omniauth_not_recoverable, provider: provider)
    else
      super
    end
  end

  # Override Devise's implementation of this method in the `Confirmable`
  # module. Devise's `Confirmable` enforces that after authentication, a user
  # still needs to be confirmed before proceeding. We override it so that
  # they can always proceed with login. We enforce confirmation by redirecting
  # to a page *after* sign in - see `root#new` logic.
  def active_for_authentication?
    true
  end

  def native?
    provider.blank?
  end

  def omniauth?
    provider.present?
  end

  # Override Devise's logic that checks if a user is `:confirmed`.
  # We assume any omniauth record has already been confirmed by the third
  # party service.
  def confirmed?
    omniauth? || super
  end

  def deactivated?
    self[:deactivated_at].present?
  end

  def name
    [first_name, last_name].join(' ')
  end

  def name=(full_name)
    self[:first_name], self[:last_name] = full_name.split(' ', 2)
  end

  def signed_in_path
    r = Rails.application.routes.url_helpers

    return(
      case
      when !confirmed?
        r.new_user_confirmation_path
      else
        r.photos_path
      end
    )
  end

  private

  # Override Devise check in `:validatable` module
  # We only want to check password presence and confirmation for native auth
  def password_required?
    native? && super
  end

  def email_domain
    return unless registration_email_domain_whitelist_enabled?

    domain = (email || '').split('@').last

    return if domain.blank?
    # rubocop:disable Style/IfUnlessModifier
    if registration_email_whitelisted_domains.any? { |d| domain =~ /#{d}/i }
      return
    end
    # rubocop:enable Style/IfUnlessModifier
    errors.add(:email, :invalid_domain, domain: domain)
  end

  def additional_password_requirements
    # `password` contains the raw password and is a synthetic field only set by
    # Devise when using the `password=` setter.
    return if password.blank?

    # When updating this:
    #   * Also check length validation in `Devise.password_length`.
    #   * Also be sure to update Frontend validations in UI
    #   * Also update the translation key for the `:password, :invalid` message
    valid = [/.{6,}/, /[0-9]/, /[a-zA-Z]/, /[!#$%&]/].all? { |p| password =~ p }
    return if valid

    # Devise adds its own password validation errors that run before this.
    # There's no easy way of pre-pending our new message to be the "first"
    # error, which is ultimately shown to the User as a flash message. Instead,
    # just wipe all password errors and then add ours.
    errors.delete(:password)
    errors.add(:password, :invalid)
  end

  def encrypted_password_is_valid_bcrypt_hash
    ::BCrypt::Password.new(encrypted_password)
  rescue BCrypt::Errors::InvalidHash
    errors.add(:encrypted_password, :invalid)
  end
end
