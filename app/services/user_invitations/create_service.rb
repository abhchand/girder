class UserInvitations::CreateService
  include Interactor

  SCHEMA =
    DryTypes::Hash.schema(
      email: DryTypes::String,
      role?: DryTypes::String
    ).with_key_transform(&:to_sym)

  after { context.user_invitation = user_invitation }

  def call
    @i18n_prefix = 'activerecord.errors.models.user_invitation.attributes.email'

    case
    when invited?
      handle_already_invited
    when registered?
      handle_already_registered
    when !valid_domain?
      handle_invalid_domain
    when !valid_role?
      handle_invalid_role
    when !create_user_invitation
      handle_failed_creation
    end
  end

  private

  def params
    @params ||= SCHEMA[**context.params.to_h]
  rescue Dry::Types::CoercionError => e
    context.fail!(error: e.message)
  end

  def user_invitation
    @user_invitation ||= UserInvitation.find_or_initialize_by(email: email)
  end

  def email
    @email ||= params[:email].downcase
  end

  def invited?
    user_invitation.persisted?
  end

  def registered?
    User.exists?(email: email)
  end

  def valid_domain?
    return true unless registration_email_domain_whitelist_enabled?

    domain = (email || '').split('@').last
    return true if domain.blank?

    registration_email_whitelisted_domains.any? { |d| domain =~ /#{d}/i }
  end

  def valid_role?
    params[:role].nil? || USER_ROLES.include?(params[:role])
  end

  def create_user_invitation
    user_invitation.attributes = params
    user_invitation.inviter = context.current_user
    user_invitation.save
  end

  def handle_already_invited
    context.fail!(
      log: "#{log_tags} Email already invited",
      error: I18n.t("#{@i18n_prefix}.already_invited"),
      status: 403
    )
  end

  def handle_already_registered
    context.fail!(
      log: "#{log_tags} Email already registered",
      error: I18n.t("#{@i18n_prefix}.already_registered"),
      status: 403
    )
  end

  def handle_invalid_domain
    domains = registration_email_whitelisted_domains.join(', ')

    context.fail!(
      log: "#{log_tags} Email domain is invalid",
      error: I18n.t("#{@i18n_prefix}.invalid_domain", domains: domains),
      status: 403
    )
  end

  def handle_invalid_role
    context.fail!(
      log: "#{log_tags} Email role is invalid",
      error: I18n.t("#{@i18n_prefix}.invalid_role"),
      status: 403
    )
  end

  def handle_failed_creation
    context.fail!(
      log:
        "#{log_tags} UserInvitation validation errors: " \
          "#{user_invitation.errors.messages}",
      error: I18n.t('generic_error'),
      status: 500
    )
  end

  def log_tags
    "[#{self.class.name}] [#{@job_id}]"
  end
end
