Dir[Rails.root.join('spec/support/helper_helpers/*.rb')].each do |file|
  require file
end

RSpec.configure { |config| config.include HelperHelpers, type: :helper }
