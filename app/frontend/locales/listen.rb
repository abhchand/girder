require 'listen'

# The `i18n-js` gem provides a listener that watches for changes and continously
# rebuilds the translations data.
#
# This file is called from an initializer.
if Rails.env.development?
  Rails.application.config.after_initialize do
    require 'i18n-js/listen'

    cfg = Rails.root.join('app', 'frontend', 'locales', 'config.yml')
    I18nJS.listen(config_file: cfg)
  end
end
