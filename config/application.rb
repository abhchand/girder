require File.expand_path('boot', __dir__)

require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'active_job/railtie'
require 'action_cable/engine'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'rails/test_unit/railtie'

# In Rails < 7 we required files individually so that we could manually
# exclude Sprockets. As of Rails 7, sprockets has been removed from 'rails/all',
# so we can just `require 'rails/all'` again instead of requiring each
# individually above
# See: https://github.com/rails/rails/pull/43261/commits/579fe208c91a0e6e941830ad5dc744c289257939
if Rails.version.split('.').first.to_i >= 7
  raise "Time to require 'rails/all' again."
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Girder
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # ActiveJob should use Sidekiq to process jobs
    # See: https://github.com/sidekiq/sidekiq/wiki/Active-Job#active-job-setup
    config.active_job.queue_adapter = :sidekiq

    # Settings in config/environments/* take precedence over those specified
    # here. Application configuration should go into files in
    # config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone. Run "rake -D time" for a list of tasks for
    # finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from
    # config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # Don't force requests from old versions of IE to be UTF-8 encoded.
    config.action_view.default_enforce_utf8 = false

    # Tell the Zeitwerk autoloader to ignore the entire app/frontend folder.
    # Ain't no ruby files there
    Rails.autoloaders.main.ignore(Rails.root.join('app/frontend'))

    # Each controller/view pair should only include it's own helpers
    config.include_all_helpers = false

    config.generators do |g|
      # Don't generate certain files during `rails generate` calls
      g.javascripts = false
      g.stylesheets = false
      g.helper = false
      g.factory_bot = false

      g.test_framework :rspec
    end

    # Custom Configs
    config.x.email_format = /\A.*@.+\..+\z/
    config.x.default_url_options =
      case
      when Rails.env.test?
        { host: 'localhost', port: '3000' }
      when Rails.env.development?
        {
          host: ENV.fetch('APP_HOST', 'localhost'),
          port: ENV.fetch('APP_PORT', '3000')
        }
      else
        { host: ENV.fetch('APP_HOST') }
      end

    Rails.application.routes.default_url_options.merge!(
      config.x.default_url_options
    )

    # Should be defaulted, but not applying on `:test` for some reason.
    # Set it explicitly
    #
    # Also see here on how to configure active job and action mailer with
    # devise and sidekiq
    # See: https://gist.github.com/maxivak/690e6c353f65a86a4af9
    config.action_mailer.deliver_later_queue_name = :mailers
  end
end
