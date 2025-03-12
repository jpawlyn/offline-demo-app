# support setting network conditions on service worker
# see:
# https://chromedevtools.github.io/devtools-protocol/tot/Target/
# https://github.com/puppeteer/puppeteer/issues/4305#issuecomment-485048253
module Selenium
  module WebDriver
    module DriverExtensions
      module HasDevTools
        def devtools_for_service_worker
          @devtools_for_service_worker ||= begin
            require 'selenium/devtools'
            Selenium::DevTools.version ||= devtools_version
            Selenium::DevTools.load_version
            Selenium::WebDriver::DevTools.new(url: devtools_url, target_type: 'service_worker')
          end
        end
      end
    end

    class DevTools
      def initialize(url:, target_type: 'page')
        @ws = WebSocketConnection.new(url: url)
        @session_id = nil
        start_session(target_type:)
      end

      private

      def start_session(target_type:)
        targets = target.get_targets.dig('result', 'targetInfos')
        found_target = targets.find { |target| target['type'] == target_type }
        session = target.attach_to_target(target_id: found_target['targetId'], flatten: true)
        @session_id = session.dig('result', 'sessionId')
      end
    end
  end
end
