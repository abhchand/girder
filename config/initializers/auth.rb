require_relative 'to_bool'

def native_auth_enabled?
  return true unless ENV.key?('NATIVE_AUTH_ENABLED')

  ENV['NATIVE_AUTH_ENABLED'].to_bool
end

def any_omniauth_enabled?
  User::OMNIAUTH_PROVIDERS.any? do |provider|
    send("provider_#{provider}_enabled?")
  end
end

def provider_google_oauth2_enabled?
  return false unless ENV.key?('GOOGLE_OMNIAUTH_ENABLED')

  ENV['GOOGLE_OMNIAUTH_ENABLED'].to_bool
end
