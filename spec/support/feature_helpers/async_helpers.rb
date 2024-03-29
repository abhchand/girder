module FeatureHelpers
  # rubocop:disable Lint/UnusedMethodArgument
  def wait_for(timeout = Capybara.default_max_wait_time, &block)
    return unless block_given?

    Timeout.timeout(timeout) { loop until yield }
  end
  # rubocop:enable Lint/UnusedMethodArgument

  def wait_for_ajax
    return unless @javascript_enabled

    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_xhr_requests?
    end
  end

  def wait_for_async_process(name, delay: 0)
    return unless @javascript_enabled

    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_async_process?(name)
    end

    wait_for do
      sleep(delay)
      true
    end
  end

  # rubocop:disable Lint/SuppressedException
  def finished_all_xhr_requests?
    page.evaluate_script('jQuery.active').tap { |result| return result.zero? }
  rescue Timeout::Error
  end

  def finished_async_process?(name)
    page
      .evaluate_script('window.asyncRegistration')
      .tap { |result| return !result.include?(name) }
  rescue Timeout::Error
  end
  # rubocop:enable Lint/SuppressedException
end
