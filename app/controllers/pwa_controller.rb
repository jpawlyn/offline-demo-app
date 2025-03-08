# The Rails::PwaController is not used since we need to disable CSP for the service worker
# since Google Workbox SW is imported from a CDN and `offline` action has been added
# https://github.com/rails/rails/pull/54657
class PwaController < ActionController::Base
  skip_forgery_protection
  layout "application", only: :offline

  def manifest; end

  def service_worker
    @offline_cached_paths = Rails.application.config.service_worker.offline_cached_paths
    @warm_cached_paths = Rails.application.config.service_worker.warm_cached_paths
    @no_fallback_paths = Rails.application.config.service_worker.no_fallback_paths
  end

  def offline; end
end
