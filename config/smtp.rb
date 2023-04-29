domain =
  if Rails.env.production? || Rails.env.staging?
    ENV.fetch('APP_HOST')
  else
    ENV.fetch('APP_HOST', 'localhost')
  end

SMTP_SETTINGS = {
  user_name: ENV['SMTP_USERNAME'],
  password: ENV['SMTP_PASSWORD'],
  domain: domain,
  address: ENV['SMTP_HOST'],
  port: ENV.fetch('SMTP_PORT', '587'),
  authentication: :plain,
  enable_starttls_auto: true
}.freeze
