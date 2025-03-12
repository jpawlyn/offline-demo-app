RSpec.configure do |config|
  config.before(:each, type: :system) do
     run_headless = ENV['HEADLESS'].blank? || ENV['HEADLESS']&.downcase == 'true'
     driven_by run_headless ? :selenium_chrome_headless : :selenium_chrome

     #  wait for service worker to register but run this just once for a test suite
     next if Thread.current[:service_worker_activated]
     visit root_path
     while !evaluate_script("navigator.serviceWorker.controller?.state === 'activated'")
       sleep 0.1
     end
     Thread.current[:service_worker_activated] = true
  end

  config.after(:each, type: :system) do
    go_online
  end
end
