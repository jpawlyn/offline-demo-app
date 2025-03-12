module NetworkCondition
  ONLINE_PARAMS = { offline: false, latency: 0, download_throughput: -1, upload_throughput: -1 }
  OFFLINE_PARAMS = { offline: true, latency: 0, download_throughput: 0, upload_throughput: 0 }

  def go_online
    page.driver.browser.devtools_for_service_worker.network.emulate_network_conditions(**ONLINE_PARAMS)
    page.driver.browser.devtools.network.emulate_network_conditions(**ONLINE_PARAMS)
  end

  def go_offline
    page.driver.browser.devtools_for_service_worker.network.enable
    page.driver.browser.devtools_for_service_worker.network.emulate_network_conditions(**OFFLINE_PARAMS)
    page.driver.browser.devtools.network.enable
    page.driver.browser.devtools.network.emulate_network_conditions(**OFFLINE_PARAMS)
  end
end

RSpec.configure do |config|
  config.include NetworkCondition, type: :system
end
