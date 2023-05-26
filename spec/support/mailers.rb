Dir[Rails.root.join('spec/support/mailers/*.rb')].each { |file| require file }

RSpec.configure { |config| config.include Mailers::HtmlHelpers, type: :mailer }
