module SettingsHelper
  def nav_links
    [
      {
        path: settings_path,
        label: t('settings.shared.nav.index'),
        selected: page_specific_css_id == 'settings-index'
      },
      {
        path: settings_users_path,
        label: t('settings.shared.nav.users'),
        selected: page_specific_css_id == 'settings-users-index'
      }
    ]
  end
end
