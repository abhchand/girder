module FeatureHelpers
  def console_logs
    browser = page.driver.browser

    logs = browser.respond_to?(:logs) ? browser.logs : browser.manage.logs
    logs.get(:browser)
  end
end
