source 'https://rubygems.org'

gem 'rails', '6.1.7'
ruby '3.0.0'

#
# Front End
#
gem 'i18n-js', '>= 3.0.0.rc11'
gem 'inline_svg', '~> 1.5', '>= 1.5.2'

#
# Back End
#
gem 'bcrypt', '~> 3.1', '>= 3.1.10'
gem 'cancancan', '~> 3.4'
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'dotenv-rails', '~> 2.8', '>= 2.8.1'
gem 'fast_jsonapi', '~> 1.6.0', git: 'https://github.com/fast-jsonapi/fast_jsonapi'
gem 'image_processing', '~> 1.12.1'
gem 'interactor', '~> 3.1', '>= 3.1.2'
gem 'omniauth', '~> 1.9'
gem 'omniauth-google-oauth2', '~> 0.8.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 3.4'
gem 'recipient_interceptor', '~> 0.2.0'
gem 'rolify', '~> 5.3'
gem 'sidekiq', '~> 5.2'
gem 'smtpapi', '~> 0.1.0'
gem 'will_paginate', '~> 3.3'

# Rails 6+ pulls in Sprockets >= 4.0, which in turn require manifest files.
# These don't exist since we don't use Sprockets (and use exclusive Webpack).
# See: https://github.com/rails/sprockets/blob/master/UPGRADING.md
#
# A future alternative is to prevent Rails from pulling in Sprockets by
# requiring Rails dependencies manually in application.rb
# See: https://andre.arko.net/2020/07/09/rails-6-with-webpack-in-appassets-and-no-sprockets/

gem 'sprockets', '~> 3.0'

#
# Vulnerabilities
#

gem 'nokogiri', '>= 1.10.4'     # https://nvd.nist.gov/vuln/detail/CVE-2019-5477
gem 'rubyzip', '>= 1.3.0'       # https://nvd.nist.gov/vuln/detail/CVE-2019-16892

group :production do
end

group :development, :test do
  gem 'factory_bot_rails', '~> 4.5'
  gem 'faker', '~> 2.10', '>= 2.10.1'
  # Prettier docs suggest to _not_ install `prettier` any more, and directly
  # install the dependencies it depends on. But... it works so far
  # https://github.com/prettier/plugin-ruby#getting-started
  gem 'prettier', '~> 3.2', '>= 3.2.2'
  gem 'prettier_print', '~> 1.2'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'rubocop', '~> 1.40'
end

group :development, :production do
  gem 'foreman', '~> 0.86.0'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', '~> 1.0'
  gem 'highline', '~> 2.0'
  gem 'letter_opener', '~> 1.7'
  gem 'rubocop-git', '~> 0.1.3'
  gem 'spring'
  gem 'web-console', '~> 4.2'
end

group :test do
  gem 'capybara', '~> 3.9'
  gem 'capybara-screenshot'
  gem 'database_cleaner', '~> 1.5', '>= 1.5.1'
  gem 'mock_redis', '~> 0.19.0'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'rake'
  gem 'selenium-webdriver', '~> 4.5.0'
  gem 'shoulda-matchers', '~> 5.0', require: false
end
