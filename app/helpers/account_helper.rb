module AccountHelper
  def nav_links
    [
      {
        path: account_index_path,
        label: t('account.shared.nav.index'),
        selected: page_specific_css_id == 'account-index'
      },
      {
        path: root_path,
        label: t('account.shared.nav.notifications'),
        selected: page_specific_css_id == 'account-notifications-index'
      }
    ]
  end
end
