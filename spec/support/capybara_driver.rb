Capybara.register_driver :headless_chrome do |app|
  capabilities =
    Selenium::WebDriver::Remote::Capabilities.chrome(
      'goog:loggingPrefs' => {
        browser: 'ALL',
        client: 'ALL',
        driver: 'ALL',
        server: 'ALL'
      }
    )

  opts = Selenium::WebDriver::Chrome::Options.new

  opts.add_argument('--headless')
  opts.add_argument('--window-size=1440,800')
  opts.add_argument('--no-sandbox')
  opts.add_argument('--disable-dev-shm-usage')
  opts.add_argument('--enable-logging')

  opts.add_preference(:download, prompt_for_download: true)
  opts.add_preference(
    :download,
    default_directory: FeatureHelpers::BROWSER_DOWNLOAD_PATH.to_s
  )
  opts.add_preference(:download, directory_upgrade: true)
  opts.add_preference(:default_content_settings, popups: 0)

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    capabilities: capabilities,
    options: opts
  )
end
