require 'rails_helper'

RSpec.describe 'settings/index.html.erb', type: :view do
  let(:user) { create(:user) }

  before { @t_prefix = 'settings.index' }
end
