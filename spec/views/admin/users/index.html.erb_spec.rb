require 'rails_helper'

RSpec.describe 'admin/users/index.html.erb', type: :view do
  let(:user) { create(:user) }
  let(:user_invitation) { create(:user_invitation, inviter: user) }

  before do
    @t_prefix = 'admin.users.index'

    stub_current_user
    assign(:users, [user_invitation, user])

    # rubocop:disable Metrics/LineLength
    stub_template 'shared/_breadcrumb_heading.html.erb' =>
                    '_stubbed_breadcrumb_heading'
    # rubocop:enable Metrics/LineLength
  end

  it 'renders the breadcrumb heading' do
    render
    expect(page).to have_content('_stubbed_breadcrumb_heading')
  end

  it 'renders the users index table' do
    render

    ids =
      page.all('.admin-users-index-table__row').map do |row|
        row['data-id']
      end

    expect(ids).to eq([user_invitation.id, user.synthetic_id].map(&:to_s))
  end
end
